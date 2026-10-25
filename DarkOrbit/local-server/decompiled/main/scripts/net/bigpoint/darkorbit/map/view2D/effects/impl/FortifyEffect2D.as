package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.EffectManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.FortifyEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class FortifyEffect2D extends AbstractShipEffect2D
   {
      
      private var _fadeInOut:Boolean = false;
      
      private var _hideShip:Boolean = true;
      
      private var _map:Map = ScreenManager.getInstance().map;
      
      private var _mapView:MapView2D;
      
      private var _effect:FortifyEffect;
      
      private var _disposed:Boolean;
      
      public function FortifyEffect2D(param1:MapView2D, param2:FortifyEffect)
      {
         this._effect = param2;
         this._hideShip = param2.hideShip;
         this._mapView = param1;
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc3_:AbstractEffect2D = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:AssetLazyLoader = null;
         var _loc1_:EffectManager = ScreenManager.getInstance().map.effects;
         var _loc2_:MapObjectEffect = _loc1_.getEffectForMapObject(ship.id,EffectIDList.STICKYBOMB_EFFECT);
         if(_loc2_)
         {
            _loc3_ = this._mapView.effectViewManager.getEffectView(_loc2_);
            if(Boolean(_loc2_) && Boolean(mapObjectView) && this._effect.source == _loc2_.source)
            {
               _loc4_ = mapObjectView;
               if(_loc4_.getChildIndex(this) > _loc4_.getChildIndex(_loc3_))
               {
                  _loc4_.swapChildren(this,_loc3_);
               }
            }
         }
         if(clip != null)
         {
            this.handlePlayOnLoaded(null);
         }
         else
         {
            _loc5_ = new AssetLazyLoader();
            _loc5_.addEventListener(AssetLazyLoader.ASSET_LOADED,this.handlePlayOnLoaded);
            _loc5_.loadAsset(pattern.resKey);
         }
      }
      
      private function handlePlayOnLoaded(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(this._hideShip)
         {
            _loc2_ = "";
            switch(ship.info.factionID.value)
            {
               case 1:
                  _loc2_ = "mmo";
                  break;
               case 2:
                  _loc2_ = "eic";
                  break;
               case 3:
                  _loc2_ = "vru";
            }
            _loc3_ = 0;
            while(_loc3_ < effectMc.numChildren)
            {
               if(effectMc.getChildAt(_loc3_) != effectMc.getChildByName(_loc2_) && effectMc.getChildAt(_loc3_) is MovieClip)
               {
                  effectMc.getChildAt(_loc3_).visible = false;
               }
               _loc3_++;
            }
         }
         TweenLite.to(ship.rotation,1,{
            "shortRotation":{"degrees":270},
            "onComplete":this.rotationCompleteHandler
         });
      }
      
      private function rotationCompleteHandler() : void
      {
         playAnimation(false,1,this._fadeInOut,false);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         ScreenManager.getInstance().eventManager.unlockMovement();
         TweenLite.killTweensOf(ship.rotation);
         if(ship)
         {
            ship.rotation.degrees = 270;
            ship.moveTrait.allowRotation = true;
         }
         if(mapObjectView)
         {
            mapObjectView.visible = true;
         }
         if(Boolean(effectMc) && !this._disposed)
         {
            this._disposed = true;
            playAnimation(false,effectMc.totalFrames,this._fadeInOut,true,true);
         }
         else
         {
            super.disposeView(param1);
         }
      }
   }
}

