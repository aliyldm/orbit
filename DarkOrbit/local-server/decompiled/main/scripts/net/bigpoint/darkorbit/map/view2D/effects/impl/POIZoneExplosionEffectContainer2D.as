package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.POIZoneExplosionContainerEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.POIZoneExplosionEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class POIZoneExplosionEffectContainer2D extends AbstractEffect2D
   {
      
      private var _explosionArea:Rectangle;
      
      private var _allocationArea:Rectangle;
      
      private var _explosionMaxStartDelay:Number;
      
      private var soundTrigger:uint = 6;
      
      private var soundID:uint = 18;
      
      private var _explosionEffects:Vector.<POIZoneExplosionEffect>;
      
      private var _screenManager:ScreenManager;
      
      private var _effect:POIZoneExplosionContainerEffect;
      
      public function POIZoneExplosionEffectContainer2D(param1:MapView2D, param2:POIZoneExplosionContainerEffect)
      {
         this._effect = param2;
         this.intialize();
         super(param1,param2);
      }
      
      protected function intialize() : void
      {
         this._explosionArea = this._effect.explosionArea;
         this._allocationArea = this._effect.allocationArea;
         this._explosionMaxStartDelay = this._effect.explosionMaxStartDelay;
         if(this._allocationArea == null)
         {
            this._allocationArea = new Rectangle(0,0,150,150);
         }
         if(this._explosionMaxStartDelay <= 0)
         {
            this._explosionMaxStartDelay = 5;
         }
         this._screenManager = ScreenManager.getInstance();
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc11_:int = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:PointLite = null;
         var _loc19_:Number = NaN;
         this._explosionEffects = new Vector.<POIZoneExplosionEffect>();
         var _loc1_:uint = this._allocationArea.width;
         var _loc2_:uint = this._allocationArea.height;
         var _loc3_:uint = Math.floor(this._explosionArea.x);
         var _loc4_:uint = Math.floor(this._explosionArea.y);
         var _loc5_:uint = Math.abs(this._explosionArea.width - this._explosionArea.x);
         var _loc6_:uint = Math.abs(this._explosionArea.height - this._explosionArea.y);
         var _loc7_:uint = Math.ceil(_loc5_ / _loc1_);
         var _loc8_:uint = Math.ceil(_loc6_ / _loc2_);
         var _loc9_:Number = 0;
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc7_)
            {
               _loc12_ = _loc11_ * _loc1_;
               _loc13_ = _loc10_ * _loc2_;
               _loc14_ = _loc12_ + 1;
               _loc15_ = _loc13_ + 1;
               _loc16_ = _loc3_ + _loc14_;
               _loc17_ = _loc4_ + _loc15_;
               _loc18_ = new PointLite(_loc16_ + this._effect.explosionCenter.x,_loc17_ + this._effect.explosionCenter.y);
               _loc19_ = this._explosionMaxStartDelay * Math.random();
               TweenLite.delayedCall(_loc19_,this.startSingleExplosion,[_loc18_,_loc9_]);
               _loc9_++;
               _loc11_++;
            }
            _loc10_++;
         }
      }
      
      protected function startSingleExplosion(param1:PointLite, param2:Number) : void
      {
         if(param2 == 0)
         {
            AudioManager.playSoundEffect(this.soundID,false,false,-1,-1,false);
         }
         this._effect.createExplosion(param1);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this._explosionEffects = null;
         TweenLite.killDelayedCallsTo(this.startSingleExplosion);
         super.disposeView(param1);
      }
   }
}

