package net.bigpoint.darkorbit.mvc.application.controller.bootup
{
   import net.bigpoint.darkorbit.map.model.minimap.MinimapMediator;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitMapViewCommand extends DOAbstractAsyncCommand
   {
      
      public function InitMapViewCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         screenManager.createLayers(this.commandComplete);
      }
      
      override protected function commandComplete() : void
      {
         facade.registerMediator(new MinimapMediator(screenManager.minimap));
         super.commandComplete();
      }
   }
}

