package net.bigpoint.darkorbit.mvc.abstract.controller
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.managers.EventManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.command.MacroCommand;
   
   public class DOAbstractMacroCommand extends MacroCommand
   {
      
      public function DOAbstractMacroCommand()
      {
         super();
      }
      
      protected function registerCommand(param1:String, param2:Class) : void
      {
         facade.registerCommand(param1,param2);
      }
      
      protected function registerProxy(param1:IProxy) : void
      {
         facade.registerProxy(param1);
      }
      
      protected function registerMediator(param1:IMediator) : void
      {
         facade.registerMediator(param1);
      }
      
      protected function retrieveMediator(param1:String) : IMediator
      {
         return facade.retrieveMediator(param1);
      }
      
      protected function retrieveProxy(param1:String) : IProxy
      {
         return facade.retrieveProxy(param1);
      }
      
      protected function hasProxy(param1:String) : Boolean
      {
         return facade.hasProxy(param1);
      }
      
      protected function getFinisherByResKey(param1:String) : FileCollectionFinisher
      {
         return ResourceManager.fileCollection.getFinisher(param1) as FileCollectionFinisher;
      }
      
      protected function get connectionProxy() : ConnectionProxy
      {
         return this.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
      }
      
      protected function get eventManager() : EventManager
      {
         return this.screenManager.eventManager;
      }
      
      protected function get screenManager() : ScreenManager
      {
         return ScreenManager.getInstance();
      }
   }
}

