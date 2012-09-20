<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>BurrDesign Administration (Nutmouse 0.1)</title>
{{tpl:admin/head.tpl}}
</head>

<body>

<div class="wrap_all">

	<div class="mainnav">
    	{{mod:admin/menu/mainmenu.php}}
    </div>
    
    <div class="wrap_content">
        <div class="navleft">
            <div class="subnav">
            	{{mod:admin/menu/submenu.php}}
            </div>
            
            <div class="quicklist">
            	{{mod:admin/menu/quicklist.php}}
            </div>
        </div>
        
        <div class="content">
        	<div class="box_inner">
            	{{main_content}}
            </div>
        </div>
    </div>
    
    <div class="wrap_footer">
    	{{tpl:admin/footer.tpl}}
    </div>

</div>

</body>
</html>