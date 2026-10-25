package net.bigpoint.darkorbit.mvc.events.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.PixelatedRenderingEvent;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HandlePixelatedRenderingEvent extends DOAbstractSimpleCommand
   {
      
      public function HandlePixelatedRenderingEvent()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:PixelatedRenderingEvent = param1.getBody() as PixelatedRenderingEvent;
         Settings.pixelatedRenderingAvailable.value = _loc2_.isActive;
      }
   }
}

