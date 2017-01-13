@TestOn("firefox")

import 'dart:html';
import "package:test/test.dart";
import 'package:mockito/mockito.dart';
import '../../web/app/utils/sidedrawer/sidedrawer.dart';
import '../../web/app/utils/sidedrawer/overlay_invoker.dart';

class OverlayInvokerMock extends Mock implements OverlayInvoker {}

void main() {

  test("Show side drawer", () {
    // Arrange
    OverlayInvokerMock overlayInvokerMock = new OverlayInvokerMock();
    Element overlayEl = querySelector("#overlay");
    when(overlayInvokerMock.invokeOverlay("on", any)).thenReturn(overlayEl);

    // Act
    SideDrawer sideDrawer = new SideDrawer(overlayInvokerMock);
    sideDrawer.showDrawer.click();

    // Assert
    expect(
        overlayEl.outerHtml,
        contains(sideDrawer.sideDrawerEl.outerHtml)
    );
  });
}