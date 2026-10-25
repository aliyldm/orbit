package net.bigpoint.darkorbit.mvc.common.model
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class ConnectionProxy extends Proxy implements IProxy
   {
      
      public static const NAME:String = "ConnectionProxy";
      
      public function ConnectionProxy()
      {
         super(NAME,null);
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         sendNotification(ConnectionNotifications.READY);
      }
      
      public function get connectionManager() : ConnectionManager
      {
         return data as ConnectionManager;
      }
      
      public function sendCommand(param1:String, param2:Array = null) : void
      {
         this.connectionManager.sendCommand(param1,param2);
      }
      
      public function sendNettyRequest(param1:IModule) : void
      {
         this.connectionManager.sendRequest(param1);
      }
      
      public function connectToMap(param1:int) : void
      {
         this.connectionManager.connectToMap(param1);
      }
   }
}

