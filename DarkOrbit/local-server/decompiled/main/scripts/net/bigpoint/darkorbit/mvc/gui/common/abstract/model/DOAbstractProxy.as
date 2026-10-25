package net.bigpoint.darkorbit.mvc.gui.common.abstract.model
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.events.model.EventProxy;
   import net.bigpoint.darkorbit.mvc.gui.common.model.GuiProxy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class DOAbstractProxy extends Proxy implements IProxy
   {
      
      public function DOAbstractProxy(param1:String, param2:Object = null)
      {
         super(param1,param2);
      }
      
      protected function getFinisher(param1:String) : FileCollectionFinisher
      {
         return ResourceManager.fileCollection.getFinisher(param1);
      }
      
      protected function get connectionProxy() : ConnectionProxy
      {
         return this.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
      }
      
      protected function get guiProxy() : GuiProxy
      {
         return this.retrieveProxy(GuiProxy.NAME) as GuiProxy;
      }
      
      protected function get assetsProxy() : AssetsProxy
      {
         return this.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
      }
      
      public function retrieveMediator(param1:String) : IMediator
      {
         return facade.retrieveMediator(param1);
      }
      
      public function retrieveProxy(param1:String) : IProxy
      {
         return facade.retrieveProxy(param1);
      }
      
      public function registerMediator(param1:IMediator) : void
      {
         facade.registerMediator(param1);
      }
      
      public function get eventProxy() : EventProxy
      {
         return facade.retrieveProxy(EventProxy.NAME) as EventProxy;
      }
      
      protected function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
   }
}

