package net.bigpoint.darkorbit.mvc.common.model.assets
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class UnloadFinisherProxy extends Proxy
   {
      
      public static const NAME:String = "UnloadFinisherProxy";
      
      public function UnloadFinisherProxy(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         sendNotification(AssetNotifications.UNLOAD_FINISHER_PROXY_READY);
      }
      
      private function get finisherList() : Vector.<FileCollectionFinisher>
      {
         return data as Vector.<FileCollectionFinisher>;
      }
      
      public function unloadAllFinisher() : void
      {
         while(this.finisherList.length > 0)
         {
            this.finisherList.pop().dispose();
         }
      }
      
      public function addFinisher(param1:FileCollectionFinisher) : void
      {
         if(param1.fileVO.id == "ui")
         {
            return;
         }
         if(Settings.unloadResources && Boolean(param1))
         {
            this.finisherList.push(param1);
         }
      }
   }
}

