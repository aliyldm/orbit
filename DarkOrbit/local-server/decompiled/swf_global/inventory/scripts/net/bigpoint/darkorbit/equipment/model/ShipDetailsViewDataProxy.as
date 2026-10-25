package net.bigpoint.darkorbit.equipment.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipDetailsViewData;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class ShipDetailsViewDataProxy extends Proxy
   {
      
      private static var _latestInfo:ShipDetailsViewData;
      
      public static const NAME:String = "ShipDetailsViewDataProxy";
      
      public static const MODEL_CHANGED:String = "ShipDetailsViewDataProxy.modelUpdated";
      
      public static const ID_SHIP:String = "ship";
      
      public static const ID_DRONES:String = "drones";
      
      public static const ID_PET:String = "pet";
      
      private static const infos:Dictionary = new Dictionary();
      
      public function ShipDetailsViewDataProxy()
      {
         super(NAME,infos);
      }
      
      public function existInfo(param1:String) : Boolean
      {
         return infos[param1] != null ? true : false;
      }
      
      public function getInfo(param1:String) : ShipDetailsViewData
      {
         var _loc2_:ShipDetailsViewData = null;
         return infos[param1];
      }
      
      public function getLatestInfo() : ShipDetailsViewData
      {
         return _latestInfo;
      }
      
      public function setInfo(param1:String, param2:ShipDetailsViewData) : void
      {
         _latestInfo = param2;
         infos[param1] = param2;
         sendNotification(ShipDetailsViewDataProxy.MODEL_CHANGED,param1);
      }
   }
}

