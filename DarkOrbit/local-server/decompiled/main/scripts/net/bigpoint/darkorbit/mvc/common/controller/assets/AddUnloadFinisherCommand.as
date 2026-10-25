package net.bigpoint.darkorbit.mvc.common.controller.assets
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UnloadFinisherProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class AddUnloadFinisherCommand extends SimpleCommand
   {
      
      public function AddUnloadFinisherCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:FileCollectionFinisher = param1.getBody() as FileCollectionFinisher;
         var _loc3_:UnloadFinisherProxy = facade.retrieveProxy(UnloadFinisherProxy.NAME) as UnloadFinisherProxy;
         _loc3_.addFinisher(_loc2_);
      }
   }
}

