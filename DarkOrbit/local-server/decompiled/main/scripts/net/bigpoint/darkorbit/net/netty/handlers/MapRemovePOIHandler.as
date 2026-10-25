package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.MapRemovePOICommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.net.POIAssembly;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MapRemovePOIHandler extends DOAbstractSimpleCommand
   {
      
      public function MapRemovePOIHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MapRemovePOICommand = param1.getBody() as MapRemovePOICommand;
         POIAssembly.getInstance().assembleRemovePOI(_loc2_.poiId);
         var _loc3_:SectorControlProxy = facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy;
         var _loc4_:int = _loc3_.getControlPointIdByPOIid(_loc2_.poiId);
         _loc3_.deletControlPointIdByPOIid(_loc2_.poiId);
         map.removeEntityById(_loc4_);
      }
   }
}

