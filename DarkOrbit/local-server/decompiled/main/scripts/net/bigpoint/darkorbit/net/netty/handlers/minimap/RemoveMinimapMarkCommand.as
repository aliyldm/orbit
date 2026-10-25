package net.bigpoint.darkorbit.net.netty.handlers.minimap
{
   import net.bigpoint.darkorbit.com.module.RemoveMinimapMark;
   import net.bigpoint.darkorbit.map.model.minimap.MapMarker;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RemoveMinimapMarkCommand extends DOAbstractSimpleCommand
   {
      
      public function RemoveMinimapMarkCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:RemoveMinimapMark = param1.getBody() as RemoveMinimapMark;
         MapMarker.stopMapMarker(_loc2_.uid);
      }
   }
}

