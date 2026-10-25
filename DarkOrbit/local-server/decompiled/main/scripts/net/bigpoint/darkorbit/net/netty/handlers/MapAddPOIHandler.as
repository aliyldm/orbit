package net.bigpoint.darkorbit.net.netty.handlers
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.MapAddPOICommand;
   import net.bigpoint.darkorbit.net.POIAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class MapAddPOIHandler extends BaseHandler
   {
      
      public function MapAddPOIHandler()
      {
         super();
      }
      
      public static function run(param1:MapAddPOICommand) : void
      {
         var _loc4_:Vector.<int> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Vector.<PointLite> = new Vector.<PointLite>();
         var _loc3_:Number = NaN;
         if(param1.shape == MapAddPOICommand.SHAPETYPE_CIRCLE)
         {
            _loc3_ = param1.shapeCoordinates[2];
            _loc2_.push(new PointLite(param1.shapeCoordinates[0],param1.shapeCoordinates[1]));
         }
         else
         {
            _loc4_ = param1.shapeCoordinates;
            while(_loc4_.length >= 2)
            {
               _loc5_ = _loc4_.shift();
               _loc6_ = _loc4_.shift();
               _loc2_.push(new PointLite(_loc5_,_loc6_));
            }
         }
         POIAssembly.getInstance().assembleCreatePOI(param1.poiId,InGameCatalog.getInstance().poizonePOITypeToZoneType(param1.poiType.typeValue),param1.poiTypeSpecification,param1.design.designValue,param1.active,param1.inverted,InGameCatalog.getInstance().poizoneShapeTypeIdToShapeString(param1.shape),_loc2_,_loc3_);
      }
   }
}

