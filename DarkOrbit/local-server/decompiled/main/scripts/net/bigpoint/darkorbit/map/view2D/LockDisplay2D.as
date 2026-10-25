package net.bigpoint.darkorbit.map.view2D
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.hud.*;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.utils.LockManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.common.model.assetProxy.MapAssetLoadVo;
   
   public class LockDisplay2D extends AbstractHUDElement
   {
      
      private var _view:MovieClip;
      
      private var _target:AttackTargetTrait;
      
      private var _lockManager:LockManager;
      
      public function LockDisplay2D(param1:IMapView)
      {
         super(param1,new BindablePointLite());
         cacheAsBitmap = true;
         GameFacade.getInstance().sendNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(this.setLogGraphic,"ui",new <String>["ship_border"],DisplayObject,null,false));
      }
      
      public function set map(param1:Map) : void
      {
         if(this._lockManager)
         {
            this._lockManager.targetChanged.remove(this.handleTargetChanged);
         }
         this._lockManager = param1 ? param1.lockManager : null;
         if(this._lockManager)
         {
            this._lockManager.targetChanged.add(this.handleTargetChanged);
         }
      }
      
      private function showLock() : void
      {
         if(this._view)
         {
            this._view.alpha = 0;
            if(this._target)
            {
               this._target.lockType.changed.add(this.updateLogType);
            }
            this.updateLogType();
            TweenLite.killTweensOf(this._view);
            TweenLite.to(this._view,0.3,{"autoAlpha":1});
         }
      }
      
      private function hideLock() : void
      {
         if(this._target)
         {
            this._target.lockType.changed.remove(this.updateLogType);
         }
         if(this._view != null)
         {
            TweenLite.killTweensOf(this._view);
            TweenLite.to(this._view,0.3,{"autoAlpha":0});
         }
      }
      
      private function handleTargetChanged(param1:MapEntity) : void
      {
         this.hideLock();
         this._target = param1 ? param1.getFirstTrait(AttackTargetTrait) as AttackTargetTrait : null;
         if(this._target)
         {
            _worldPosition = this._target.owner.position;
            this.showLock();
         }
      }
      
      private function setLogGraphic(param1:MovieClip) : void
      {
         this._view = param1;
         this.updateLogType();
         addChild(this._view);
         this._view.alpha = 0;
      }
      
      private function updateLogType() : void
      {
         if(Boolean(this._view) && Boolean(this._target))
         {
            if(this._target.lockType.value <= this._view.totalFrames)
            {
               this._view.gotoAndStop(this._target.lockType.value);
            }
            else
            {
               this._view.gotoAndStop(1);
            }
         }
      }
   }
}

