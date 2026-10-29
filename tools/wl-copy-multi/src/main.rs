// wl-copy-multi <image.png>
// Puts one screenshot on the clipboard in several formats at once:
//   image/png      -> browsers, nvim (img-clip), chat apps
//   text/uri-list  -> file managers
//   text/plain     -> terminals get the file path
use std::{env, fs, path::Path, process};
use wl_clipboard_rs::copy::{MimeSource, MimeType, Options, Source};

fn main() {
    let arg = env::args().nth(1).unwrap_or_else(|| {
        eprintln!("usage: wl-copy-multi <image.png>");
        process::exit(2)
    });
    let path = fs::canonicalize(Path::new(&arg)).unwrap_or_else(|e| {
        eprintln!("{arg}: {e}");
        process::exit(1)
    });
    let png = fs::read(&path).expect("read image");
    let p = path.to_string_lossy().into_owned();
    let uri = format!("file://{p}");

    let mut srcs = vec![MimeSource {
        source: Source::Bytes(png.into()),
        mime_type: MimeType::Specific("image/png".into()),
    }];
    srcs.push(MimeSource { source: Source::Bytes(uri.into_bytes().into()), mime_type: MimeType::Specific("text/uri-list".into()) });
    for t in ["text/plain;charset=utf-8", "text/plain", "UTF8_STRING", "STRING", "TEXT"] {
        srcs.push(MimeSource { source: Source::Bytes(p.clone().into_bytes().into()), mime_type: MimeType::Specific(t.into()) });
    }
    // Forks a background owner that serves the clipboard until something else is copied
    let mut o = Options::new();
    o.foreground(true);
    o.copy_multi(srcs).expect("copy to clipboard");
}
