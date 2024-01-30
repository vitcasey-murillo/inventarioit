import DataTable from "datatables.net-vue3";
import DataTablesLib from "datatables.net-bs5";
import Buttons from "datatables.net-buttons-bs5";
import ButtonHtml5 from "datatables.net-buttons/js/buttons.html5";
import print from "datatables.net-buttons/js/buttons.print";

//import pdfMake from "pdfmake/build/pdfmake";
//import pdfFonts from "pdfmake/build/vfs_fonts";
//pdfMake.vfs = pdfFonts.pdfMake.vfs;

import "datatables.net-responsive-bs5";
import JsZip from "jszip";
window.JSZip = JsZip;

DataTable.use(DataTablesLib);
//DataTable.use(pdfMake);
DataTable.use(ButtonHtml5);

export { DataTable };
