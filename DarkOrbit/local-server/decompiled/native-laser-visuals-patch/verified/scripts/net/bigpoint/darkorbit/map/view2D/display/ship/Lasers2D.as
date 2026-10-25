package net.bigpoint.darkorbit.map.view2D.display.ship
{
   import com.bigpoint.utils.PointLite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ExpansionPattern;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.model.traits.weapons.ILaserPositionProvider;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class Lasers2D implements ILaserPositionProvider, IDisposable
   {
      
      private const DEGTORAD:Number = 0.017453292519943295;
      
      private const RADTODEG:Number = 57.29577951308232;
      
      private var _ship:Ship;
      
      private var _fuselage:ShipClip;
      
      private var _dirty:Boolean = true;
      
      private var _salvos:Vector.<Vector.<String>>;
      
      private var _cannons:Object;
      
      public function Lasers2D(param1:Ship, param2:ShipClip)
      {
         super();
         this._ship = param1;
         this._fuselage = param2;
         this._fuselage.changed.add(this.markDirty);
         this._ship.laserExpansionStage.changed.add(this.markDirty);
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._fuselage.changed.remove(this.markDirty);
         this._ship.laserExpansionStage.changed.remove(this.markDirty);
      }
      
      private function get shipPattern() : ShipPattern
      {
         return this._ship.shipPattern;
      }
      
      private function get expansionPattern() : ExpansionPattern
      {
         if(!this._ship.shipPattern.hasExpansion())
         {
            return null;
         }
         var _loc1_:Array = PatternManager.expansionClasses[this._ship.shipPattern.expansionClassID];
         if(!_loc1_)
         {
            return null;
         }
         var _loc2_:* = int(Math.max(1,Math.min(4,this._ship.laserExpansionStage.value)));
         while(_loc2_ > 1 && !_loc1_[_loc2_])
         {
            _loc2_--;
         }
         return _loc1_[_loc2_] || _loc1_[0];
      }
      
      public function getSalvos() : Vector.<Vector.<String>>
      {
         if(this._dirty)
         {
            this.validate();
         }
         return this._salvos;
      }
      
      public function getLaserCannonLocalPosition(param1:String, param2:Vector3D, param3:Number = NaN) : void
      {
         var _loc6_:PointLite = null;
         if(this._dirty)
         {
            this.validate();
         }
         var _loc4_:Vector.<PointLite> = this._cannons[param1];
         if(!_loc4_ || _loc4_.length == 0)
         {
            param2.setTo(0,0,0);
            return;
         }
         var _loc5_:Number = !isNaN(param3) ? param3 : this._ship.rotation.degrees;
         while(_loc5_ < 0)
         {
            _loc5_ += 360;
         }
         _loc6_ = _loc4_[int(_loc5_ * _loc4_.length / 360 + 0.5) % _loc4_.length];
         param2.x = _loc6_.x;
         param2.y = _loc6_.y;
         param2.z = 0;
      }
      
      private function markDirty() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:* = 0;
         var _loc1_:MovieClip = this._fuselage.clip;
         if(Boolean(_loc1_) && _loc1_.framesLoaded == 1)
         {
            _loc3_ = int(_loc1_.numChildren - 1);
            while(_loc3_ >= 0)
            {
               _loc2_ = _loc1_.getChildAt(_loc3_);
               if(_loc2_.name.search("laser") != -1)
               {
                  _loc2_.visible = false;
               }
               _loc3_--;
            }
         }
         this._dirty = true;
      }
      
      private function validate() : void
      {
         var _loc2_:ExpansionPattern = null;
         this._salvos = null;
         this._cannons = null;
         var _loc1_:MovieClip = this._fuselage.clip;
         if(this._dirty && _loc1_ != null)
         {
            _loc2_ = this.expansionPattern;
            if(_loc2_)
            {
               this._salvos = _loc2_.salvos;
               this._cannons = _loc2_.cannons;
            }
            else if(_loc1_.framesLoaded == 1)
            {
               this.initSimpleLaserPositions(_loc1_);
            }
         }
         if(this._salvos == null || this._cannons == null)
         {
            this._salvos = new Vector.<Vector.<String>>();
            this._salvos.push(Vector.<String>["mainCannon"]);
            this._cannons = {};
            if(_loc1_ != null)
            {
               this._cannons["mainCannon"] = this.initSimpleLaserPositions(_loc1_);
            }
         }
         this._dirty = false;
      }
      
      private function initSimpleLaserPositions(param1:MovieClip) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:PointLite = null;
         var _loc7_:Vector.<PointLite> = null;
         var _loc8_:int = 0;
         if(this.shipPattern.simpleShipSalvos == null)
         {
            this.shipPattern.simpleShipSalvos = new Vector.<Vector.<String>>();
            this.shipPattern.simpleShipSalvos.push(new Vector.<String>());
            this.shipPattern.simpleShipCannons = {};
            _loc3_ = int(param1.numChildren - 1);
            while(_loc3_ >= 0)
            {
               _loc2_ = param1.getChildAt(_loc3_);
               if(_loc2_.name.search("laser") != -1)
               {
                  _loc4_ = Math.sqrt(_loc2_.x * _loc2_.x + _loc2_.y * _loc2_.y);
                  _loc5_ = Math.round(Math.atan2(_loc2_.y,_loc2_.x) * this.RADTODEG);
                  _loc7_ = new Vector.<PointLite>();
                  _loc8_ = 0;
                  while(_loc8_ < 360)
                  {
                     _loc6_ = new PointLite();
                     _loc6_.x = int(_loc4_ * Math.cos((_loc8_ + _loc5_) * this.DEGTORAD));
                     _loc6_.y = int(_loc4_ * Math.sin((_loc8_ + _loc5_) * this.DEGTORAD));
                     _loc7_.push(_loc6_);
                     _loc8_++;
                  }
                  this.shipPattern.simpleShipSalvos[0].push("cannon" + _loc3_);
                  this.shipPattern.simpleShipCannons["cannon" + _loc3_] = _loc7_;
               }
               _loc3_--;
            }
            if(this.shipPattern.simpleShipSalvos[0].length == 0)
            {
               this.shipPattern.simpleShipSalvos[0].push("mainCannon");
            }
         }
         this._salvos = this.shipPattern.simpleShipSalvos;
         this._cannons = this.shipPattern.simpleShipCannons;
      }
   }
}

