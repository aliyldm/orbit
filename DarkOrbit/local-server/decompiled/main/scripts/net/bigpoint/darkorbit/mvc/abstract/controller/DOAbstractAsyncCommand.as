package net.bigpoint.darkorbit.mvc.abstract.controller
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.managers.EventManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.common.model.GuiProxy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class DOAbstractAsyncCommand extends AsyncCommand
   {
      
      public function DOAbstractAsyncCommand()
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
      
      protected function hasMediator(param1:String) : Boolean
      {
         return facade.hasMediator(param1);
      }
      
      protected function hasCommand(param1:String) : Boolean
      {
         return facade.hasCommand(param1);
      }
      
      protected function get assetsProxy() : AssetsProxy
      {
         return this.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
      }
      
      protected function get connectionProxy() : ConnectionProxy
      {
         return this.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
      }
      
      protected function get guiProxy() : GuiProxy
      {
         return this.retrieveProxy(GuiProxy.NAME) as GuiProxy;
      }
      
      protected function getFinisherByResKey(param1:String) : FileCollectionFinisher
      {
         return ResourceManager.fileCollection.getFinisher(param1) as FileCollectionFinisher;
      }
      
      protected function get guiManager() : GuiManager
      {
         return GuiManager.instance;
      }
      
      protected function get eventManager() : EventManager
      {
         return this.screenManager.eventManager;
      }
      
      protected function get screenManager() : ScreenManager
      {
         return ScreenManager.getInstance();
      }
      
      protected function get uiSysten() : UISystem
      {
         return UISystem.getInstance();
      }
   }
}

