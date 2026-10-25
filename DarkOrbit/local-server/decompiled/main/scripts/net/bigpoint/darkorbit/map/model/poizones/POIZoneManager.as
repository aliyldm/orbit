package net.bigpoint.darkorbit.map.model.poizones
{
   import away3d.debug.Trident;
   import com.bigpoint.utils.PointLite;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZone;
   import net.bigpoint.darkorbit.map.model.poizones.polygon.PoligonZone;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZone;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class POIZoneManager
   {
      
      private static const MAGIC_OFFSET:int = 55;
      
      private static const MAGIC_CHECKPOINTS:Vector.<Point> = new <Point>[new Point(MAGIC_OFFSET,MAGIC_OFFSET),new Point(-MAGIC_OFFSET,-MAGIC_OFFSET),new Point(MAGIC_OFFSET,-MAGIC_OFFSET),new Point(-MAGIC_OFFSET,MAGIC_OFFSET),new Point(0,MAGIC_OFFSET),new Point(0,-MAGIC_OFFSET),new Point(MAGIC_OFFSET,0),new Point(-MAGIC_OFFSET,0)];
      
      private const debugTridant:Trident = new Trident();
      
      public const ready:ISignal = new Signal();
      
      private var _hash2id:Object = {};
      
      private var _map:Map;
      
      private var _list:EntityTraitContainer;
      
      public function POIZoneManager(param1:Map)
      {
         super();
         this._map = param1;
      }
      
      public function addZone(param1:String, param2:String, param3:String, param4:int, param5:String, param6:Boolean, param7:Boolean, param8:Vector.<PointLite>, param9:Number = NaN) : POIZone
      {
         var _loc10_:POIZone = null;
         var _loc11_:int = 0;
         this.removeZone(param1);
         switch(param5)
         {
            case POIZone.SHAPE_CIRCLE:
               _loc10_ = new CircleZone(Map.NEXT_FREE_ID,param2,param8[0],param9,param7,param4);
               break;
            case POIZone.SHAPE_RECT:
               _loc10_ = new RectangleZone(Map.NEXT_FREE_ID,param2,param8,param7,param4);
               break;
            case POIZone.SHAPE_POLYGON:
               _loc10_ = new PoligonZone(Map.NEXT_FREE_ID,param2,param8,param7,param4);
         }
         this._hash2id[param1] = _loc10_.id;
         this._map.addEntity(_loc10_);
         _loc10_.zoneTypeSpecification.value = param3;
         if(param2 == POIZone.ZONE_TYPE_SECTOR_CONTROL_SECTOR_ZONE)
         {
            _loc11_ = Map.NEXT_FREE_ID;
            (GameFacade.getInstance().retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy).storePOIControlPointMapping(param1,_loc11_);
            HandlerLookup.execute(new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_SECTOR_CONTROL_SECTOR_ZONE),"",0,"",_loc11_,0,0,_loc10_.position.x,_loc10_.position.y,0,false,false,false,false,null,null));
         }
         return _loc10_;
      }
      
      public function registerZone(param1:String, param2:POIZone, param3:String) : void
      {
         this._hash2id[param1] = param2.id;
         this._map.addEntity(param2);
         param2.zoneTypeSpecification.value = param3;
      }
      
      public function removeZone(param1:String) : void
      {
         this._map.removeEntityById(this._hash2id[param1]);
         this._hash2id[param1] = null;
         delete this._hash2id[param1];
      }
      
      public function getZoneById(param1:String) : POIZone
      {
         return this._map.getEntityById(this._hash2id[param1]) as POIZone;
      }
      
      public function checkCollisions(param1:Point, param2:Point) : Point
      {
         var _loc5_:Intersection = null;
         var _loc6_:IPOIZoneCollisionArea = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:net.bigpoint.darkorbit.map.model.poizones.Line = null;
         var _loc10_:Point = null;
         var _loc11_:String = null;
         var _loc12_:Point = null;
         var _loc13_:Circle = null;
         var _loc14_:Point = null;
         var _loc3_:Point = param2.subtract(param1);
         _loc3_.normalize(MAGIC_OFFSET);
         param2 = param2.add(_loc3_);
         var _loc4_:Vector.<Intersection> = new Vector.<Intersection>();
         if(this._list == null)
         {
            this._list = this._map.getTraitsList(IPOIZoneCollisionArea);
         }
         for each(_loc6_ in this._list.traits)
         {
            if(((_loc6_ as EntityTraitBase).owner as POIZone).zoneType == POIZone.ZONE_TYPE_NOA)
            {
               _loc5_ = _loc6_.hitTest(param1,param2);
               if(_loc5_)
               {
                  _loc4_.push(_loc5_);
               }
            }
         }
         if(_loc4_.length == 0)
         {
            return null;
         }
         _loc4_.sort(Intersection.compare);
         _loc5_ = _loc4_[0];
         if(_loc5_.intersectionObject is net.bigpoint.darkorbit.map.model.poizones.Line)
         {
            _loc9_ = _loc5_.intersectionObject as net.bigpoint.darkorbit.map.model.poizones.Line;
            _loc7_ = _loc5_.subtract(param1);
            _loc10_ = _loc9_.getNormal();
            _loc10_.normalize(MAGIC_OFFSET);
            _loc11_ = _loc9_.whereAboutSegment(param1);
            if(_loc11_ == net.bigpoint.darkorbit.map.model.poizones.Line.FRONT)
            {
               _loc7_ = _loc7_.add(_loc10_);
            }
            else if(_loc11_ == net.bigpoint.darkorbit.map.model.poizones.Line.BEHIND)
            {
               _loc7_ = _loc7_.subtract(_loc10_);
            }
            else if(_loc11_ == net.bigpoint.darkorbit.map.model.poizones.Line.ON_SEGMENT)
            {
               for each(_loc12_ in MAGIC_CHECKPOINTS)
               {
                  if(!this.zoneContains(param1.add(_loc12_)))
                  {
                     _loc7_ = _loc12_;
                     break;
                  }
               }
            }
         }
         else if(_loc5_.intersectionObject is Circle)
         {
            _loc13_ = _loc5_.intersectionObject as Circle;
            _loc7_ = _loc5_.subtract(param1);
            _loc14_ = _loc13_.getNormalOfPoint(_loc5_,!_loc13_.inverted);
            _loc14_.normalize(MAGIC_OFFSET);
            _loc7_ = _loc7_.subtract(_loc14_);
         }
         _loc8_ = param1.add(_loc7_);
         if(this.zoneContains(_loc8_))
         {
            if(this.zoneContains(param1))
            {
               for each(_loc12_ in MAGIC_CHECKPOINTS)
               {
                  if(!this.zoneContains(param1.add(_loc12_)))
                  {
                     return param1.add(_loc12_);
                  }
               }
            }
            return param1;
         }
         return _loc8_;
      }
      
      public function zoneContains(param1:Point) : Boolean
      {
         var _loc4_:IPOIZoneCollisionArea = null;
         if(this._list == null)
         {
            this._list = this._map.getTraitsList(IPOIZoneCollisionArea);
         }
         var _loc2_:Vector.<EntityTraitBase> = this._list.traits;
         var _loc3_:int = int(_loc2_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _loc2_[_loc5_] as IPOIZoneCollisionArea;
            if(_loc4_.contains(param1))
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public function explodePOIZone(param1:String) : void
      {
         var _loc3_:RectangleZone = null;
         var _loc2_:POIZone = this.getZoneById(param1);
         if(Boolean(_loc2_) && _loc2_ is RectangleZone)
         {
            _loc3_ = _loc2_ as RectangleZone;
         }
      }
      
      public function cleanup() : void
      {
         this._hash2id = {};
      }
      
      public function get zones() : Object
      {
         return this._hash2id;
      }
   }
}

