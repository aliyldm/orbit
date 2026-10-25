package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.Geometry;
   import away3d.entities.Mesh;
   import away3d.primitives.PlaneGeometry;
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AttackRangeExceededCommand;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.OutOfRangeEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.utils.Helper;
   
   public class OutOfRangeEffect3D implements IUpdatable
   {
      
      private static const markersActive:Dictionary = new Dictionary();
      
      private static const maxMarkersPerType:uint = 5;
      
      private static const _geometry:Geometry = new PlaneGeometry(1,1);
      
      private static const TYPE_2_RESKEY:Object = {};
      
      TYPE_2_RESKEY[AttackRangeExceededCommand.ATTACKTYPE_LASER] = "Laser";
      TYPE_2_RESKEY[AttackRangeExceededCommand.ATTACKTYPE_ROCKET] = "Rocket";
      TYPE_2_RESKEY[AttackRangeExceededCommand.ATTACKTYPE_HELLSTORM] = "Hellstorm";
      TYPE_2_RESKEY[AttackRangeExceededCommand.ATTACKTYPE_MISC] = "Misc";
      
      private const RADTODEG:Number = 57.29577951308232;
      
      private var _mapView:MapView3D;
      
      private var _hero:MapEntity;
      
      private var _distVect:Vector3D = new Vector3D();
      
      private var _limiterParent:ObjectContainer3D = new ObjectContainer3D();
      
      public function OutOfRangeEffect3D(param1:MapView3D, param2:OutOfRangeEffect)
      {
         super();
         this._mapView = param1;
         this._mapView.gameWorld.addChild(this._limiterParent);
         this._mapView.addUpdatable(this);
         if(param2.target)
         {
            this._hero = param2.source;
            this.addLimitMarker(this._hero,param2.target,param2.maxRange,param2.type);
            setTimeout(this.addLimitMarker,33,this._hero,param2.target,param2.maxRange,param2.type);
            setTimeout(this.addLimitMarker,660,this._hero,param2.target,param2.maxRange,param2.type);
         }
      }
      
      private function addLimitMarker(param1:MapEntity, param2:MapEntity, param3:int, param4:int) : void
      {
         if(markersActive[param4] == undefined)
         {
            markersActive[param4] = 0;
         }
         if(markersActive[param4] >= maxMarkersPerType)
         {
            return;
         }
         markersActive[param4] += 1;
         var _loc5_:String = "outOfRangeLimiter" + TYPE_2_RESKEY[param4];
         var _loc6_:MovieClip = ResourceManager.getMovieClip("ui",_loc5_);
         var _loc7_:Mesh = Helper.movieclip2mesh(_loc5_,_loc6_,_geometry);
         this._distVect.setTo(param2.x3D - param1.x3D,param2.y3D - param1.y3D,param2.z3D - param1.z3D);
         this._distVect.normalize();
         this._distVect.scaleBy(param3);
         _loc7_.x = this._distVect.x;
         _loc7_.y = this._distVect.y;
         _loc7_.z = this._distVect.z;
         _loc7_.scaleX = _loc6_.width;
         _loc7_.scaleZ = _loc6_.height;
         _loc7_.rotationY = 90 - Math.atan2(this._distVect.z,this._distVect.x) * this.RADTODEG;
         this._limiterParent.addChild(_loc7_);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_OUT_OF_RANGE);
         setTimeout(this.removeAndCount,2000,_loc7_,param4);
      }
      
      public function updateObj(param1:Number) : void
      {
         this._limiterParent.x = this._hero.x3D;
         this._limiterParent.y = this._hero.y3D;
         this._limiterParent.z = this._hero.z3D;
      }
      
      private function removeAndCount(param1:Mesh, param2:uint) : void
      {
         if(Boolean(param1) && Boolean(param1.parent))
         {
            param1.parent.removeChild(param1);
         }
         markersActive[param2] = markersActive[param2] - 1;
         if(this._limiterParent.numChildren == 0)
         {
            this._mapView.removeUpdatable(this);
            if(this._limiterParent.parent)
            {
               this._limiterParent.parent.removeChild(this._limiterParent);
            }
         }
      }
   }
}

