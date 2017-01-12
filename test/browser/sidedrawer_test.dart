@TestOn("content-shell")
@Skip("currently failing")

import "package:test/test.dart";
import '../../web/app/utils/sidedrawer.dart';

void main() {

  @Ignore
  test("Show side drawer", () {
    SideDrawer sideDrawer = new SideDrawer();
    sideDrawer.showDrawer.click();
  });
}