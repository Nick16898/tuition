var nodemailer = require("nodemailer");
/*global process */
const user = process.env.TUITION_EMAIL_USER;
const pass = process.env.TUITION_EMAIL_PASS;

const logoUrl = process.env.TUITION_MEDIA_URL + "logo.png"; // logo url here

const informative_mail = async (title = "", message = "") => {
  var tmplate = "";
  //template header starts
  tmplate +=
    '<html xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office" style="width:100%;font-family:lato, \'helvetica neue\', helvetica, arial, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0">';
  tmplate += "<head>";
  tmplate += '<meta charset="UTF-8">';
  tmplate +=
    '<meta content="width=device-width, initial-scale=1" name="viewport">';
  tmplate += '<meta name="x-apple-disable-message-reformatting">';
  tmplate += '<meta http-equiv="X-UA-Compatible" content="IE=edge">';
  tmplate += '<meta content="telephone=no" name="format-detection">';
  tmplate += "<title>" + title + "</title>";
  tmplate +=
    '<link href="https://fonts.googleapis.com/css?family=Lato:400,400i,700,700i" rel="stylesheet">';
  tmplate += '<style type="text/css">';
  tmplate += "#outlook a {";
  tmplate += "padding: 0;";
  tmplate += "}";
  tmplate += ".ExternalClass {";
  tmplate += "width: 100%;";
  tmplate += "}";
  tmplate += ".ExternalClass,";
  tmplate += ".ExternalClass p,";
  tmplate += ".ExternalClass span,";
  tmplate += ".ExternalClass font,";
  tmplate += ".ExternalClass td,";
  tmplate += ".ExternalClass div {";
  tmplate += "line-height: 100%;";
  tmplate += "}";
  tmplate += ".es-button {";
  tmplate += "mso-style-priority: 100!important;";
  tmplate += "text-decoration: none!important;";
  tmplate += "}";
  tmplate += "a[x-apple-data-detectors] {";
  tmplate += "color: inherit!important;";
  tmplate += "text-decoration: none!important;";
  tmplate += "font-size: inherit!important;";
  tmplate += "font-family: inherit!important;";
  tmplate += "font-weight: inherit!important;";
  tmplate += "line-height: inherit!important;";
  tmplate += "}";
  tmplate += ".es-desk-hidden {";
  tmplate += "display: none;";
  tmplate += "float: left;";
  tmplate += "overflow: hidden;";
  tmplate += "width: 0;";
  tmplate += "max-height: 0;";
  tmplate += "line-height: 0;";
  tmplate += "mso-hide: all;";
  tmplate += "}";
  tmplate += ".re-buttom{";
  tmplate += "margin: 10px;";
  tmplate += "border: none;";
  tmplate += "background: #ab0e1e;";
  tmplate += "color: white;";
  tmplate += "border-radius: 5px;";
  tmplate += "padding: 10px;";
  tmplate += "width: 250px;";
  tmplate += "cursor: pointer;";
  tmplate += "}";
  tmplate += "[data-ogsb] .es-button {";
  tmplate += "border-width: 0!important;";
  tmplate += "padding: 15px 25px 15px 25px!important;";
  tmplate += "}";
  tmplate += "@media only screen and (max-width:600px) {";
  tmplate += "p,";
  tmplate += "ul li,";
  tmplate += "ol li,";
  tmplate += "a {";
  tmplate += "line-height: 150%!important";
  tmplate += "}";
  tmplate += "h1,";
  tmplate += "h2,";
  tmplate += "h3,";
  tmplate += "h1 a,";
  tmplate += "h2 a,";
  tmplate += "h3 a {";
  tmplate += "line-height: 120%!important";
  tmplate += "}";
  tmplate += "h1 {";
  tmplate += "font-size: 30px!important;";
  tmplate += "text-align: center";
  tmplate += "}";
  tmplate += "h2 {";
  tmplate += "font-size: 26px!important;";
  tmplate += "text-align: center";
  tmplate += "}";
  tmplate += "h3 {";
  tmplate += "font-size: 20px!important;";
  tmplate += "text-align: center";
  tmplate += "}";
  tmplate += ".es-header-body h1 a,";
  tmplate += ".es-content-body h1 a,";
  tmplate += ".es-footer-body h1 a {";
  tmplate += "font-size: 30px!important";
  tmplate += "}";
  tmplate += ".es-header-body h2 a,";
  tmplate += ".es-content-body h2 a,";
  tmplate += ".es-footer-body h2 a {";
  tmplate += "font-size: 26px!important";
  tmplate += "}";
  tmplate += ".es-header-body h3 a,";
  tmplate += ".es-content-body h3 a,";
  tmplate += ".es-footer-body h3 a {";
  tmplate += "font-size: 20px!important";
  tmplate += "}";
  tmplate += ".es-menu td a {";
  tmplate += "font-size: 16px!important";
  tmplate += "}";
  tmplate += ".es-header-body p,";
  tmplate += ".es-header-body ul li,";
  tmplate += ".es-header-body ol li,";
  tmplate += ".es-header-body a {";
  tmplate += "font-size: 16px!important";
  tmplate += "}";
  tmplate += ".es-content-body p,";
  tmplate += ".es-content-body ul li,";
  tmplate += ".es-content-body ol li,";
  tmplate += ".es-content-body a {";
  tmplate += "font-size: 16px!important";
  tmplate += "}";
  tmplate += ".es-footer-body p,";
  tmplate += ".es-footer-body ul li,";
  tmplate += ".es-footer-body ol li,";
  tmplate += ".es-footer-body a {";
  tmplate += "font-size: 16px!important";
  tmplate += "}";
  tmplate += ".es-infoblock p,";
  tmplate += ".es-infoblock ul li,";
  tmplate += ".es-infoblock ol li,";
  tmplate += ".es-infoblock a {";
  tmplate += "font-size: 12px!important";
  tmplate += "}";
  tmplate += '*[class="gmail-fix"] {';
  tmplate += "display: none!important";
  tmplate += "}";
  tmplate += ".es-m-txt-c,";
  tmplate += ".es-m-txt-c h1,";
  tmplate += ".es-m-txt-c h2,";
  tmplate += ".es-m-txt-c h3 {";
  tmplate += "text-align: center!important";
  tmplate += "}";
  tmplate += ".es-m-txt-r,";
  tmplate += ".es-m-txt-r h1,";
  tmplate += ".es-m-txt-r h2,";
  tmplate += ".es-m-txt-r h3 {";
  tmplate += "text-align: right!important";
  tmplate += "}";
  tmplate += ".es-m-txt-l,";
  tmplate += ".es-m-txt-l h1,";
  tmplate += ".es-m-txt-l h2,";
  tmplate += ".es-m-txt-l h3 {";
  tmplate += "text-align: left!important";
  tmplate += "}";
  tmplate += ".es-m-txt-r img,";
  tmplate += ".es-m-txt-c img,";
  tmplate += ".es-m-txt-l img {";
  tmplate += "display: inline!important";
  tmplate += "}";
  tmplate += "es-button-border {";
  tmplate += "display: block!important";
  tmplate += "}";
  tmplate += "a.es-button,";
  tmplate += "button.es-button {";
  tmplate += "font-size: 20px!important;";
  tmplate += "display: block!important;";
  tmplate += "border-width: 15px 25px 15px 25px!important";
  tmplate += "}";
  tmplate += ".es-btn-fw {";
  tmplate += "border-width: 10px 0px!important;";
  tmplate += "text-align: center!important";
  tmplate += "}";
  tmplate += ".es-adaptive table,";
  tmplate += ".es-btn-fw,";
  tmplate += ".es-btn-fw-brdr,";
  tmplate += ".es-left,";
  tmplate += ".es-right {";
  tmplate += "width: 100%!important";
  tmplate += "}";
  tmplate += ".es-content table,";
  tmplate += ".es-header table,";
  tmplate += ".es-footer table,";
  tmplate += ".es-content,";
  tmplate += ".es-footer,";
  tmplate += ".es-header {";
  tmplate += "width: 100%!important;";
  tmplate += "max-width: 600px!important";
  tmplate += "}";
  tmplate += ".es-adapt-td {";
  tmplate += "display: block!important;";
  tmplate += "width: 100%!important";
  tmplate += "}";
  tmplate += ".adapt-img {";
  tmplate += "width: 100%!important;";
  tmplate += "height: auto!important";
  tmplate += "}";
  tmplate += ".es-m-p0 {";
  tmplate += "padding: 0px!important";
  tmplate += "}";
  tmplate += ".es-m-p0r {";
  tmplate += "padding-right: 0px!important";
  tmplate += "}";
  tmplate += ".es-m-p0l {";
  tmplate += "padding-left: 0px!important";
  tmplate += "}";
  tmplate += ".es-m-p0t {";
  tmplate += "padding-top: 0px!important";
  tmplate += "}";
  tmplate += ".es-m-p0b {";
  tmplate += "padding-bottom: 0!important";
  tmplate += "}";
  tmplate += ".es-m-p20b {";
  tmplate += "padding-bottom: 20px!important";
  tmplate += "}";
  tmplate += ".es-mobile-hidden,";
  tmplate += ".es-hidden {";
  tmplate += "display: none!important";
  tmplate += "}";
  tmplate += "tr.es-desk-hidden,";
  tmplate += "td.es-desk-hidden,";
  tmplate += "table.es-desk-hidden {";
  tmplate += "width: auto!important;";
  tmplate += "overflow: visible!important;";
  tmplate += "float: none!important;";
  tmplate += "max-height: inherit!important;";
  tmplate += "line-height: inherit!important";
  tmplate += "}";
  tmplate += "tr.es-desk-hidden {";
  tmplate += "display: table-row!important";
  tmplate += "}";
  tmplate += "table.es-desk-hidden {";
  tmplate += "display: table!important";
  tmplate += "}";
  tmplate += "td.es-desk-menu-hidden {";
  tmplate += "display: table-cell!important";
  tmplate += "}";
  tmplate += ".es-menu td {";
  tmplate += "width: 1%!important";
  tmplate += "}";
  tmplate += "table.es-table-not-adapt,";
  tmplate += ".esd-block-html table {";
  tmplate += "width: auto!important";
  tmplate += "}";
  tmplate += "table.es-social {";
  tmplate += "display: inline-block!important";
  tmplate += "}";
  tmplate += "table.es-social td {";
  tmplate += "display: inline-block!important";
  tmplate += "}";
  tmplate += "}";
  tmplate += "</style>";
  tmplate += "</head>";
  tmplate +=
    "<body style=\"width:100%;font-family:lato, 'helvetica neue', helvetica, arial, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0\"> ";
  tmplate += '<div class="es-wrapper-color" style="background-color:#F4F4F4"> ';
  tmplate +=
    '<table class="es-wrapper" width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top"> ';
  tmplate +=
    '<tr class="gmail-fix" height="0" style="border-collapse:collapse"> ';
  tmplate += '<td style="padding:0;Margin:0"> ';
  tmplate +=
    '<table cellspacing="0" cellpadding="0" border="0" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;width:600px"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td cellpadding="0" cellspacing="0" border="0" style="padding:0;Margin:0;line-height:1px;min-width:600px" height="0"><img src="https://viiirc.stripocdn.email/content/guids/CABINET_837dc1d79e3a5eca5eb1609bfe9fd374/images/41521605538834349.png" style="display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;max-height:0px;min-height:0px;min-width:600px;width:600px" alt width="600" height="1"></td> ';
  tmplate += "</tr> ";
  tmplate += "</table> ";
  tmplate += "</td> ";
  tmplate += "</tr> ";
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate += '<td valign="top" style="padding:0;Margin:0"> ';
  tmplate +=
    '<table class="es-header" cellspacing="0" cellpadding="0" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background: linear-gradient(#292826 100%, #292826 100%);background-repeat:repeat;background-position:center top"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td align="center" style="padding:0;Margin:0;background: linear-gradient(#292826 100%, #292826 100%);> ';
  tmplate +=
    '<table class="es-header-body" cellspacing="0" cellpadding="0" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;width:600px"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td align="left" style="Margin:0;padding-bottom:10px;padding-left:10px;padding-right:10px;padding-top:20px"> ';
  tmplate +=
    '<table width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td valign="top" align="center" style="padding:0;Margin:0;width:580px"> ';
  tmplate +=
    '<table width="100%" cellspacing="0" cellpadding="0" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td align="center" style="Margin:0;padding-left:10px;padding-right:10px;padding-top:25px;padding-bottom:25px;font-size:0"><img src="' +
    logoUrl +
    '" alt style="width: 80px; display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic"></td> ';
  tmplate += "</tr> ";
  tmplate += "</table> ";
  tmplate += "</td> ";
  tmplate += "</tr> ";
  tmplate += "</table> ";
  tmplate += "</td> ";
  tmplate += "</tr> ";
  tmplate += "</table> ";
  tmplate += "</td> ";
  tmplate += "</tr> ";
  tmplate += "</table> ";
  tmplate +=
    '<table class="es-content" cellspacing="0" cellpadding="0" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td style="padding:0;Margin:0;background: linear-gradient(#292826 100%, #292826 100%) align="center"> ';
  tmplate +=
    '<table class="es-content-body" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;width:600px" cellspacing="0" cellpadding="0" align="center"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate += '<td align="left" style="padding:0;Margin:0"> ';
  tmplate +=
    '<table width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td valign="top" align="center" style="padding:0;Margin:0;width:600px"> ';
  tmplate +=
    '<table style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:separate;border-spacing:0px;background-color:#ffffff;border-radius:4px" width="100%" cellspacing="0" cellpadding="0" bgcolor="#ffffff" role="presentation"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td align="center" style="Margin:0;padding-bottom:5px;padding-left:30px;padding-right:30px;padding-top:35px"> ';
  tmplate +=
    "<h6 style=\"Margin:0;line-height:58px;mso-line-height-rule:exactly;font-family:lato, 'helvetica neue', helvetica, arial, sans-serif;font-size:35px;font-style:normal;font-weight:normal;color:#111111\">" +
    title +
    "</h6> ";
  tmplate += "</td> ";
  tmplate += "</tr> ";
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td bgcolor="#ffffff" align="center" style="Margin:0;padding-top:5px;padding-bottom:5px;padding-left:20px;padding-right:20px;font-size:0"> ';
  tmplate +=
    '<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td style="padding:0;Margin:0;border-bottom:1px solid #ffffff;background:#FFFFFF none repeat scroll 0% 0%;height:1px;width:100%;margin:0px"></td> ';
  tmplate += "</tr> ";
  tmplate += "</table> ";
  tmplate += "</td> ";
  tmplate += "</tr> ";
  tmplate += "</table> ";
  tmplate += "</td> ";
  tmplate += "</tr> ";
  tmplate += "</table> ";
  tmplate += "</td> ";
  tmplate += "</tr> ";
  tmplate += "</table> ";
  tmplate += "</td> ";
  tmplate += "</tr> ";
  tmplate += "</table> ";
  tmplate +=
    '<table class="es-content" cellspacing="0" cellpadding="0" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate += '<td align="center" style="padding:0;Margin:0"> ';
  tmplate +=
    '<table class="es-content-body" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;width:600px" cellspacing="0" cellpadding="0" align="center"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate += '<td align="left" style="padding:0;Margin:0"> ';
  tmplate +=
    '<table width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td valign="top" align="center" style="padding:0;Margin:0;width:600px"> ';
  tmplate +=
    '<table style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:separate;border-spacing:0px;border-radius:4px;background-color:#ffffff" width="100%" cellspacing="0" cellpadding="0" bgcolor="#ffffff" role="presentation"> ';
  tmplate += '<tr style="border-collapse:collapse"> ';
  tmplate +=
    '<td class="es-m-txt-l" align="left" style="padding:0;Margin:0;padding-top:20px;padding-left:30px;padding-right:30px"> ';
  tmplate += message;
  tmplate += "</td>";
  tmplate += "</tr>";
  tmplate += '<tr style="border-collapse:collapse">';
  tmplate +=
    '<td class="es-m-txt-l" align="left" style="Margin:0;padding-top:20px;padding-left:30px;padding-right:30px;padding-bottom:40px">';
  tmplate += "</td>";
  tmplate += "</tr>";
  tmplate += "</table>";
  tmplate += "</td>";
  tmplate += "</tr>";
  tmplate += "</table>";
  tmplate += "</td>";
  tmplate += "</tr>";
  tmplate += "</table>";
  tmplate += "</td>";
  tmplate += "</tr>";
  tmplate += "</table>";
  tmplate += "</td>";
  tmplate += "</tr>";
  tmplate += "</table>";
  tmplate += "</div>";
  tmplate += "</body>";
  tmplate += "</html>";
  return tmplate;
};

const informative_mail_new = async (
  title = "",
  subtitle = "",
  message = ""
) => {
  let template = `<!DOCTYPE HTML
  		PUBLIC "-//W3C//DTD XHTML 1.0 Transitional //EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml"
		xmlns:o="urn:schemas-microsoft-com:office:office">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="x-apple-disable-message-reformatting">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title></title>
		<style type="text/css">
			@media only screen and (min-width: 620px) {
			.u-row {
				width: 600px !important;
			}
			.u-row .u-col {
				vertical-align: top;
			}
			.u-row .u-col-37p74 {
				width: 226.44px !important;
			}
			.u-row .u-col-62p26 {
				width: 373.56px !important;
			}
			.u-row .u-col-100 {
				width: 600px !important;
			}
			}
			@media (max-width: 620px) {
			.u-row-container {
				max-width: 100% !important;
				padding-left: 0px !important;
				padding-right: 0px !important;
			}
			.u-row .u-col {
				min-width: 320px !important;
				max-width: 100% !important;
				display: block !important;
			}
			.u-row {
				width: 100% !important;
			}
			.u-col {
				width: 100% !important;
			}
			.u-col>div {
				margin: 0 auto;
			}
			.no-stack .u-col {
				min-width: 0 !important;
				display: table-cell !important;
			}
			.no-stack .u-col-100 {
				width: 100% !important;
			}
			}
			body {
			margin: 0;
			padding: 0;
			}
			table,
			tr,
			td {
			vertical-align: top;
			border-collapse: collapse;
			}
			p {
			margin: 0;
			}
			.ie-container table,
			.mso-container table {
			table-layout: fixed;
			}
			* {
			line-height: inherit;
			}
			a[x-apple-data-detectors='true'] {
			color: inherit !important;
			text-decoration: none !important;
			}
			table,
			td {
			color: #000000;
			}
			@media (max-width: 480px) {
			#u_content_image_3 .v-container-padding-padding {
				padding: 25px 10px 0px !important;
			}
			#u_content_image_3 .v-src-width {
				width: auto !important;
			}
			#u_content_image_3 .v-src-max-width {
				max-width: 35% !important;
			}
			#u_content_image_3 .v-text-align {
				text-align: left !important;
			}
			#u_content_heading_5 .v-font-size {
				font-size: 14px !important;
			}
			#u_content_heading_3 .v-container-padding-padding {
				padding: 30px 10px 10px !important;
			}
			#u_content_heading_3 .v-font-size {
				font-size: 22px !important;
			}
			#u_content_heading_3 .v-line-height {
				line-height: 120% !important;
			}
			#u_content_divider_1 .v-container-padding-padding {
				padding: 0px 10px 10px !important;
			}
			#u_content_image_1 .v-src-width {
				width: auto !important;
			}
			#u_content_image_1 .v-src-max-width {
				max-width: 100% !important;
			}
			#u_content_text_4 .v-container-padding-padding {
				padding: 20px 0px 10px !important;
			}
			#u_content_text_4 .v-font-size {
				font-size: 13px !important;
			}
			#u_content_text_4 .v-text-align {
				text-align: center !important;
			}
			#u_content_image_2 .v-container-padding-padding {
				padding: 10px 0px 20px !important;
			}
			#u_content_image_2 .v-src-width {
				width: auto !important;
			}
			#u_content_image_2 .v-src-max-width {
				max-width: 51% !important;
			}
			#u_content_image_2 .v-text-align {
				text-align: center !important;
			}
			}
		</style>
		<link href="https://fonts.googleapis.com/css2?family=Arvo&display=swap" rel="stylesheet" type="text/css">
		</head>
		<body class="clean-body u_body"
		style="margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #ecedf1;color: #000000">
		<table
			style="border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #ecedf1;width:100%"
			cellpadding="0" cellspacing="0">
			<tbody>
			<tr style="vertical-align: top">
				<td style="word-break: break-word;border-collapse: collapse !important;vertical-align: top">
				<div class="u-row-container" style="padding: 0px;background-color: transparent">
					<div class="u-row"
					style="margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;">
					<div
						style="border-collapse: collapse;display: table;width: 100%;height: 100%;background-color: transparent;">
						<div class="u-col u-col-100"
						style="max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;">
						<div style="background-color: #e6eaf2;height: 100%;width: 100% !important;">
							<div
							style="box-sizing: border-box; height: 100%; padding: 0px;border-top: 10px solid #ffffff;border-left: 10px solid #ffffff;border-right: 10px solid #ffffff;border-bottom: 0px solid transparent;">
							<table id="u_content_image_3" style="font-family:arial,helvetica,sans-serif;" role="presentation"
								cellpadding="0" cellspacing="0" width="100%" border="0">
								<tbody>
								<tr>
									<td class="v-container-padding-padding"
									style="overflow-wrap:break-word;word-break:break-word;padding:25px 20px 15px 10px;font-family:arial,helvetica,sans-serif;"
									align="left">
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
										<td class="v-text-align" style="padding-right: 0px;padding-left: 0px;" align="right">
											<img align="right" border="0" src="images/image-3.png" alt="image" title="image"
											style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 16%;max-width: 91.2px;"
											width="91.2" class="v-src-width v-src-max-width" />
										</td>
										</tr>
									</table>
									</td>
								</tr>
								</tbody>
							</table>
							</div>
						</div>
						</div>
					</div>
					</div>
				</div>
				<div class="u-row-container" style="padding: 0px;background-color: transparent">
					<div class="u-row no-stack"
					style="margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;">
					<div
						style="border-collapse: collapse;display: table;width: 100%;height: 100%;background-color: transparent;">
						<div class="u-col u-col-100"
						style="max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;">
						<div style="background-color: #e6eaf2;height: 100%;width: 100% !important;">
							<div
							style="box-sizing: border-box; height: 100%; padding: 0px 14px 0px 0px;border-top: 0px solid transparent;border-left: 10px solid #ffffff;border-right: 10px solid #ffffff;border-bottom: 10px solid #ffffff;">
							<table id="u_content_heading_5" style="font-family:arial,helvetica,sans-serif;"
								role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
								<tbody>
								<tr>
									<td class="v-container-padding-padding"
									style="overflow-wrap:break-word;word-break:break-word;padding:30px 10px 0px;font-family:arial,helvetica,sans-serif;"
									align="left">
									<h2 class="v-text-align v-line-height v-font-size"
										style="margin: 0px; color: #5c5c5c; line-height: 140%; text-align: left; word-wrap: break-word; font-family: inherit; font-size: 20px; font-weight: 400;">
										<span>${title}</span>
									</h2>
									</td>
								</tr>
								</tbody>
							</table>
							</div>
						</div>
						</div>
					</div>
					</div>
				</div>
				<div class="u-row-container" style="padding: 0px;background-color: transparent">
					<div class="u-row"
					style="margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;">
					<div
						style="border-collapse: collapse;display: table;width: 100%;height: 100%;background-color: transparent;">
						<div class="u-col u-col-100"
						style="max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;">
						<div
							style="background-color: #ffffff;height: 100%;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;">
							<div
							style="box-sizing: border-box; height: 100%; padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;">
							<table id="u_content_heading_3" style="font-family:arial,helvetica,sans-serif;"
								role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
								<tbody>
								<tr>
									<td class="v-container-padding-padding"
									style="overflow-wrap:break-word;word-break:break-word;padding:30px 170px 10px 20px;font-family:arial,helvetica,sans-serif;"
									align="left">
									<h1 class="v-text-align v-line-height v-font-size"
										style="margin: 0px; line-height: 120%; text-align: left; word-wrap: break-word; font-family: Arvo; font-size: 30px; font-weight: 400;">
										<span style="line-height: 26.4px;">${subtitle}</span>
									</h1>
									</td>
								</tr>
								<tr>
									<td>
									<p class="v-text-align v-line-height v-font-size"
									style="margin: 0px; color: #7E8C8D; line-height: 140%;padding:10px 40px 20px 25px; text-align: left; word-wrap: break-word; font-family: inherit; font-size: 14px; font-weight: 400;">
									${message}
									</p>
									</td>
								</tr>
								</tbody>
							</table>
							<table id="u_content_divider_1" style="font-family:arial,helvetica,sans-serif;"
								role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
								<tbody>
								<tr>
									<td class="v-container-padding-padding"
									style="overflow-wrap:break-word;word-break:break-word;padding:0px 10px 10px 20px;font-family:arial,helvetica,sans-serif;"
									align="left">
									<table height="0px" align="left" border="0" cellpadding="0" cellspacing="0" width="45%"
										style="border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 10px solid #e6eaf2;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%">
										<tbody>
										<tr style="vertical-align: top">
											<td
											style="word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%">
											<span>&#160;</span>
											</td>
										</tr>
										</tbody>
									</table>
									</td>
								</tr>
								</tbody>
							</table>
							<table id="u_content_image_1" style="font-family:arial,helvetica,sans-serif;" role="presentation"
								cellpadding="0" cellspacing="0" width="100%" border="0">
								<tbody>
								<tr>
									<td class="v-container-padding-padding"
									style="overflow-wrap:break-word;word-break:break-word;padding:0px;font-family:arial,helvetica,sans-serif;"
									align="left">
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
										<td class="v-text-align" style="padding-right: 0px;padding-left: 0px;" align="right">
											<img align="right" border="0" src="images/image-2.png" alt="image" title="image"
											style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 90%;max-width: 540px;"
											width="540" class="v-src-width v-src-max-width" />
										</td>
										</tr>
									</table>
									</td>
								</tr>
								</tbody>
							</table>
							</div>
						</div>
						</div>
					</div>
					</div>
				</div>
				<div class="u-row-container" style="padding: 0px;background-color: transparent">
					<div class="u-row"
					style="margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;">
					<div style="border-collapse: collapse;display: table;width: 100%;height: 100%;background-color: transparent;">
						<div class="u-col u-col-62p26"
						style="max-width: 320px;min-width: 373.56px;display: table-cell;vertical-align: top;">
						<div
							style="background-color: #000000;height: 100%;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;">
							<div
							style="box-sizing: border-box; height: 100%; padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;">
							<table id="u_content_text_4" style="font-family:arial,helvetica,sans-serif;" role="presentation"
								cellpadding="0" cellspacing="0" width="100%" border="0">
								<tbody>
								<tr>
									<td class="v-container-padding-padding"
									style="overflow-wrap:break-word;word-break:break-word;padding:20px 10px 20px 40px;font-family:arial,helvetica,sans-serif;"
									align="left">
									<div class="v-text-align v-line-height v-font-size"
										style="font-size: 13px; color: #ffffff; line-height: 140%; text-align: left; word-wrap: break-word;">
										<p style="line-height: 140%;">2013-24 © XpertLab Technologies Private Limited. All Rights Reserved.</p>
									</div>
									</td>
								</tr>
								</tbody>
							</table>
							</div>
						</div>
						</div>
						<div class="u-col u-col-37p74"
						style="max-width: 320px;min-width: 226.44px;display: table-cell;vertical-align: top;">
						<div
							style="background-color: #000000;height: 100%;width: 100% !important;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;">
							<div
							style="box-sizing: border-box; height: 100%; padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;border-radius: 0px;-webkit-border-radius: 0px; -moz-border-radius: 0px;">
							<table id="u_content_image_2" style="font-family:arial,helvetica,sans-serif;" role="presentation"
								cellpadding="0" cellspacing="0" width="100%" border="0">
								<tbody>
								<tr>
									<td class="v-container-padding-padding"
									style="overflow-wrap:break-word;word-break:break-word;padding:10px 30px 10px 10px;font-family:arial,helvetica,sans-serif;"
									align="left">
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
										<td class="v-text-align" style="padding-right: 0px;padding-left: 0px;" align="right">
											<img align="right" border="0" src="images/image-1.png" alt="image" title="image"
											style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 100%;max-width: 149px;"
											width="149" class="v-src-width v-src-max-width" />
										</td>
										</tr>
									</table>
									</td>
								</tr>
								</tbody>
							</table>
							</div>
						</div>
						</div>
					</div>
					</div>
				</div>
				</td>
			</tr>
			</tbody>
		</table>
		</body>
		</html>
	`;
  return template;
};

const AdminVerifyEmail = async (title = "", message = "") => {
  let template = `
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Email Verification - Fiore's Digital Services</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: #050e24;
                        margin: 0;
                        padding: 0;
                    }
                    .container {
                        max-width: 600px;
                        margin: 30px auto;
                        padding: 20px;
                        background-color: #F69312;
                        border-radius: 10px;
                        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
                    }
                    .header {
                        background-color: white;
                        color: #050e24;
                        text-align: center;
                        padding: 20px;
                        border-radius: 10px 10px 0 0;
                    }
                    .logo {
                        width: 150px;
                    }
                    .content {
                        padding: 20px;
                        color: #050e24;
                        text-align: center;
                    }
                    .content .otp {
                        display: inline-block;
                        font-size: 24px;
                        color: #050e24;
                        background-color: #ffffff;
                        padding: 10px 20px;
                        border-radius: 5px;
                        font-weight: bold;
                        margin: 20px 0;
                    }
                    .footer {
                        background-color: #eaeaea;
                        text-align: center;
                        padding: 10px;
                        font-size: 14px;
                        color: #333333;
                        border-radius: 0 0 10px 10px;
                    }
                    .footer a {
                        color: #050e24;
                        text-decoration: none;
                        font-weight: bold;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <!-- Header Section -->
                    <div class="header">
                        <img src="${logoUrl}" alt="Fiore's Digital Services Logo" class="logo">
                    </div>

                    <!-- Content Section -->
                    <div class="content">
                        <h1>${title}</h1>
                        <p>Welcome to <strong>Fiore's Digital Services</strong>! To complete your registration, please verify your email address by using the OTP below:</p>
                        <div class="otp">${message}</div>
                        <p><strong>Note:</strong> This OTP is valid for the next 5 minutes. If you did not sign up, please ignore this email.</p>
                        <p>Need help? <a href="#">Contact our support team</a>.</p>
                        <p>Best Regards,</p>
                        <p>The Fiore's Digital Services Team</p>
                    </div>

                    <!-- Footer Section -->
                    <div class="footer">
                        <p>© ${new Date().getFullYear()} Fiore's Digital Services. All rights reserved.</p>
                        <p>Having trouble? Reach out at <a href="#">support@email.com</a></p>
                    </div>
                </div>
            </body>
            </html>
            `;
  return template;
};

const forgetPassword = async (title = "", message = "") => {
  let template = `<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Email Verification - talkify</title>
</head>

<body style="margin: 0; padding: 0; background-color: #fff; font-family: Arial, sans-serif; color: #050e24;">
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td align="center">
                <!-- Outer Table -->
                <table width="700" cellpadding="0" cellspacing="0" border="0"
                    style="border: 1px solid gray;border-radius: 10px; overflow: hidden; padding: 10px 10px; font-size: 18px;background-size: cover; background-position: center;"
                    background="https://web.xpertlab.com/camel/api/talkify/helpers/1.jpg">
                    <tr>
                        <td style="padding: 0;">
                            <!-- Background Blur Overlay Simulation -->
                            <table width="100%" cellpadding="0" cellspacing="0" border="0"
                                style="background-color: rgba(255,255,255,0.55);">
                                <!-- Header -->
                                <tr>
                                    <td align="center"
                                        style="padding: 20px; margin-bottom:10px; background-color: rgba(231, 231, 231, 0.492); border-radius: 10px 10px 0 0;">
                                        <img src="${logoUrl}" alt="talkify Logo" width="120" style="display:block;">
                                    </td>
                                </tr>

                                <!-- Divider -->
                                <tr>
                                    <td>
                                        <hr style="margin: 0;">
                                    </td>
                                </tr>

                                <!-- Main Content -->
                                <tr>
                                    <td align="center" style="padding: 20px;">
                                        <h1 style="margin: 0;">${title}</h1>
                                        <p>You recently requested to reset your password for <strong>India talkify
                                                Association</strong>. Use the OTP below to reset your password:</p>
                                        <div
                                            style="display: inline-block; font-size: 24px; background-color: rgba(231, 231, 231, 0.874); padding: 10px 20px; border-radius: 5px; font-weight: bold; margin: 20px 0;">
                                            ${message}
                                        </div>
                                        <p><strong>Note:</strong> This OTP is valid for the next 5 minutes. If you did
                                            not request a password reset, please ignore this email.</p>
                                        <p>Need help? <a href="#"
                                                style="font-size: 18px; color: black; font-weight: bold;">Contact our
                                                support team.</a></p>
                                        <p>Best Regards,</p>
                                        <p>The India talkify Association Team</p>
                                    </td>
                                </tr>

                                <!-- Divider -->
                                <tr>
                                    <td>
                                        <hr style="margin: 0;">
                                    </td>
                                </tr>

                                <!-- Footer -->
                                <tr>
                                    <td align="center"
                                        style="padding: 10px; background-color: rgba(231, 231, 231, 0.492); border-radius: 0 0 10px 10px;">
                                        <p>© ${new Date().getFullYear()} India talkify Association. All rights reserved.
                                        </p>
                                        <p>Having trouble? Reach out at <a href="#"
                                                style="color: #050e24; font-weight: bold;">support@email.com</a></p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>`;
  return template;
};

const send_mail_to_user = async (to, subject, content, type = "") => {
  var appData;
  if (type == "AdminVerifyEmail") {
    appData = await AdminVerifyEmail(subject, content);
  } else if (type == "forgetPassword") {
    appData = await forgetPassword(subject, content);
  } else {
    appData = await informative_mail(subject, content);
  }

  var transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: user,
      pass: pass,
    },
    tls: {
      rejectUnauthorized: false, // Ignore certificate errors
    },
  });
  var mailOptions = {
    from: user,
    to: to,
    subject: subject,
    html: `${appData}`,
  };
  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log("Error in Sending Mail", error);
    } else {
      console.log("Email sent: " + info.response);
    }
  });
};

module.exports = {
  send_mail_to_user,
};
