package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   
   public class CompactCannonLinks3D implements IUpdatable
   {
      
      private static const instance:CompactCannonLinks3D = new CompactCannonLinks3D();
      
      private var map:MapView3D;
      
      private var active:Vector.<CompactCannonLink3D> = new Vector.<CompactCannonLink3D>();
      
      private var spare:Array = [];
      
      private var batches:Vector.<CompactCannonBatch3D> = new Vector.<CompactCannonBatch3D>();
      
      private var registered:Boolean = false;
      
      private var listening:Boolean = false;
      
      private var hits:uint;
      
      private var created:uint;
      
      private var peak:uint;
      
      private var updates:uint;
      
      public function CompactCannonLinks3D()
      {
         super();
      }
      
      public static function acquire(param1:PointLite, param2:PointLite, param3:Number = 0) : IDisposable
      {
         return instance.add(param1,param2,param3);
      }
      
      private function add(param1:PointLite, param2:PointLite, param3:Number) : IDisposable
      {
         var _loc4_:CompactCannonBatch3D = null;
         var _loc5_:CompactCannonBatch3D = null;
         var _loc6_:CompactCannonLink3D = null;
         if(!this.listening)
         {
            World3D.instance.resetSignal.add(this.clear);
            this.listening = true;
         }
         if(this.map !== World3D.instance.mapView)
         {
            this.clear();
            this.map = World3D.instance.mapView;
         }
         for each(_loc5_ in this.batches)
         {
            if(_loc5_.count < 128)
            {
               _loc4_ = _loc5_;
               break;
            }
         }
         if(!_loc4_)
         {
            _loc4_ = new CompactCannonBatch3D();
            this.batches.push(_loc4_);
            this.map.gameWorld.addChild(_loc4_.rim);
            this.map.gameWorld.addChild(_loc4_.core);
         }
         if(this.spare.length)
         {
            _loc6_ = this.spare.pop();
            ++this.hits;
         }
         else
         {
            _loc6_ = new CompactCannonLink3D();
            ++this.created;
         }
         ++_loc6_.generation;
         _loc6_.owner = this;
         _loc6_.from = param1;
         _loc6_.to = param2;
         _loc6_.batch = _loc4_;
         _loc6_.elapsed = 0;
         _loc6_.lastTick = -1;
         _loc6_.lifetime = param3;
         _loc6_.index = this.active.length;
         _loc6_.active = true;
         var _loc7_:int = 0;
         while(_loc7_ < CompactCannonLink3D.PIECES)
         {
            _loc4_.rim.addSegment(_loc6_.rims[_loc7_]);
            _loc4_.core.addSegment(_loc6_.cores[_loc7_]);
            _loc7_++;
         }
         ++_loc4_.count;
         _loc4_.rim.visible = _loc4_.core.visible = true;
         this.active.push(_loc6_);
         this.peak = Math.max(this.peak,this.active.length);
         this.updateLink(_loc6_,0);
         if(!this.registered)
         {
            this.map.addUpdatable(this);
            this.registered = true;
         }
         return new CompactCannonLease3D(_loc6_,_loc6_.generation);
      }
      
      public function release(param1:CompactCannonLink3D) : void
      {
         if(!param1.active)
         {
            return;
         }
         param1.active = false;
         var _loc2_:CompactCannonLink3D = this.active.pop();
         if(_loc2_ !== param1)
         {
            this.active[param1.index] = _loc2_;
            _loc2_.index = param1.index;
         }
         var _loc3_:int = 0;
         while(_loc3_ < CompactCannonLink3D.PIECES)
         {
            param1.batch.rim.removeSegment(param1.rims[_loc3_]);
            param1.batch.core.removeSegment(param1.cores[_loc3_]);
            _loc3_++;
         }
         if(--param1.batch.count == 0)
         {
            param1.batch.rim.visible = param1.batch.core.visible = false;
         }
         param1.from = param1.to = null;
         param1.batch = null;
         param1.owner = null;
         if(this.spare.length < 256)
         {
            this.spare.push(param1);
         }
         if(this.active.length == 0 && this.registered)
         {
            this.map.removeUpdatable(this);
            this.registered = false;
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc3_:CompactCannonLink3D = null;
         var _loc2_:* = int(this.active.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this.active[_loc2_];
            _loc3_.elapsed += param1;
            if(_loc3_.lifetime > 0 && _loc3_.elapsed >= _loc3_.lifetime)
            {
               this.release(_loc3_);
            }
            else
            {
               this.updateLink(_loc3_,_loc3_.elapsed);
            }
            _loc2_--;
         }
      }
      
      private function updateLink(param1:CompactCannonLink3D, param2:Number) : void
      {
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc3_:Number = Math.min(1,param2 / 0.1);
         var _loc4_:Number = param1.lifetime > 0 ? Math.min(1,(param1.lifetime - param2) / 0.15) : 1;
         var _loc5_:Vector3D = param1.start;
         var _loc6_:Vector3D = param1.end;
         var _loc7_:Number = param1.from.x;
         var _loc8_:Number = param1.from.z;
         var _loc9_:Number = -param1.from.y;
         var _loc10_:Number = _loc7_ + (param1.to.x - _loc7_) * _loc3_;
         var _loc11_:Number = _loc8_ + (param1.to.z - _loc8_) * _loc3_;
         var _loc12_:Number = _loc9_ + (-param1.to.y - _loc9_) * _loc3_;
         if(_loc10_ == _loc7_ && _loc11_ == _loc8_ && _loc12_ == _loc9_)
         {
            _loc10_ += 0.001;
         }
         var _loc13_:int = int(param2 * 8);
         var _loc14_:Number = 0.82 + 0.18 * Math.sin(_loc13_ * 1.7 + param1.generation);
         var _loc15_:uint = this.color(1264504,_loc4_ * _loc14_);
         var _loc16_:uint = this.color(8577023,_loc4_ * _loc14_);
         if(_loc5_.x == _loc7_ && _loc5_.y == _loc8_ && _loc5_.z == _loc9_ && _loc6_.x == _loc10_ && _loc6_.y == _loc11_ && _loc6_.z == _loc12_ && param1.lastTick == _loc13_ && param1.lastColor == _loc16_)
         {
            return;
         }
         _loc5_.setTo(_loc7_,_loc8_,_loc9_);
         _loc6_.setTo(_loc10_,_loc11_,_loc12_);
         param1.lastColor = _loc16_;
         param1.lastTick = _loc13_;
         var _loc17_:Number = _loc10_ - _loc7_;
         var _loc18_:Number = _loc12_ - _loc9_;
         var _loc19_:Number = Math.sqrt(_loc17_ * _loc17_ + _loc18_ * _loc18_);
         var _loc20_:Number = Math.min(12,_loc19_ * 0.035);
         var _loc21_:Number = _loc19_ > 0.001 ? -_loc18_ / _loc19_ : 0;
         var _loc22_:Number = _loc19_ > 0.001 ? _loc17_ / _loc19_ : 0;
         var _loc23_:int = 0;
         while(_loc23_ <= CompactCannonLink3D.PIECES)
         {
            _loc24_ = _loc23_ / CompactCannonLink3D.PIECES;
            _loc25_ = _loc23_ == 0 || _loc23_ == CompactCannonLink3D.PIECES ? 0 : _loc20_ * (_loc23_ & 1 ? 1 : -1) * (0.45 + 0.55 * Math.abs(Math.sin(_loc23_ * 7.31 + _loc13_ * 1.37 + param1.generation * 2.11)));
            param1.points[_loc23_].setTo(_loc7_ + _loc17_ * _loc24_ + _loc21_ * _loc25_,_loc8_ + (_loc11_ - _loc8_) * _loc24_,_loc9_ + _loc18_ * _loc24_ + _loc22_ * _loc25_);
            _loc23_++;
         }
         _loc23_ = 0;
         while(_loc23_ < CompactCannonLink3D.PIECES)
         {
            param1.rims[_loc23_].updateSegment(param1.points[_loc23_],param1.points[_loc23_ + 1],null,_loc15_,_loc15_,3.6);
            param1.cores[_loc23_].updateSegment(param1.points[_loc23_],param1.points[_loc23_ + 1],null,_loc16_,_loc16_,1.25);
            _loc23_++;
         }
         ++this.updates;
      }
      
      private function color(param1:uint, param2:Number) : uint
      {
         return int((param1 >> 16 & 0xFF) * param2) << 16 | int((param1 >> 8 & 0xFF) * param2) << 8 | int((param1 & 0xFF) * param2);
      }
      
      private function clear() : void
      {
         var _loc1_:CompactCannonLink3D = null;
         var _loc2_:CompactCannonBatch3D = null;
         if(this.registered && Boolean(this.map))
         {
            this.map.removeUpdatable(this);
         }
         this.registered = false;
         for each(_loc1_ in this.active)
         {
            _loc1_.active = false;
            _loc1_.owner = null;
            _loc1_.from = _loc1_.to = null;
            _loc1_.batch = null;
         }
         this.active.length = 0;
         this.spare.length = 0;
         for each(_loc2_ in this.batches)
         {
            if(_loc2_.rim.parent)
            {
               _loc2_.rim.parent.removeChild(_loc2_.rim);
            }
            if(_loc2_.core.parent)
            {
               _loc2_.core.parent.removeChild(_loc2_.core);
            }
            _loc2_.rim.material.dispose();
            _loc2_.core.material.dispose();
            _loc2_.rim.dispose();
            _loc2_.core.dispose();
         }
         this.batches.length = 0;
         this.map = null;
      }
   }
}

