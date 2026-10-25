package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class InitContextMenuCommand extends AsyncCommand
   {
      
      private var startupVO:StartupVO;
      
      public function InitContextMenuCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.startupVO = param1.getBody() as StartupVO;
         var _loc2_:ContextMenu = new ContextMenu();
         _loc2_.hideBuiltInItems();
         _loc2_.builtInItems.quality = true;
         var _loc3_:ContextMenuItem = new ContextMenuItem(BPLocale.getItem("label_version").replace(/%VERSION%/,Main.VERSION));
         _loc2_.customItems.push(_loc3_);
         this.startupVO.main.contextMenu = _loc2_;
         commandComplete();
      }
   }
}

