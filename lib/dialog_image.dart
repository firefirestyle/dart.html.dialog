part of dialog;

class ImgageDialog {
  Dialog base;
  String dialogName;
//  String fileBtnId;
//  String uploadBtnId;
  String closeBtn;

  ImgageDialog({this.dialogName: "dialog_load_img", this.closeBtn: "closeBtn"}) {
    base = new Dialog(this.dialogName);
  }

  init() {
    base.init();
  }

  Future<String> show({String src:"", bool isCancel:true,int zIndex:19999}) {
    Completer completer = new Completer();
    html.ImageElement imageTmp = null;
    List<String> c = [
      """<h3>Image Uploader</h3>""", //
      """<input id="${dialogName}_file" style="display:block" type="file">""",
      """<div id="imgCont"></div>""",
      """<button id="${dialogName}_upload" style="display:none; padding: 12px 24px;">upload</button>""",
      """<button id="${dialogName}_close" style="display:inline; padding: 12px 24px;">close</button>""",
    ];
    html.Element elm = base.show(c.join("\r\n"),zIndex);
    var uploadBtn = elm.querySelector("#${dialogName}_upload");

    //
    bool click = false;
    uploadBtn.onClick.listen((_) async {
      if(click == true) {
        return "";
      }
      click = true;
      uploadBtn.style.display = "none";
      try {
          this.close();
      } finally {
        click = false;
        uploadBtn.style.display = "inline";
        completer.complete(imageTmp.src);
      }
    });
    var closeBtn = elm.querySelector("#${dialogName}_close");
    closeBtn.onClick.listen((_) {
      this.close();
      completer.complete("");
    });
    var fileBtn = elm.querySelector("#${dialogName}_file");
    fileBtn.onChange.listen((html.Event e) async {
      if (fileBtn.files.length == 0) {
        return;
      }
      fileBtn.style.display = "none";
      uploadBtn.style.display = "inline";
      imageTmp = await ImageUtil.resizeImage(await ImageUtil.loadImage(fileBtn.files[0]));
      imageTmp.id = "currentImage";
      base.content.querySelector("#imgCont").children.add(imageTmp);
    });

    return completer.future;
  }

  close() {
    base.close();
  }
}
