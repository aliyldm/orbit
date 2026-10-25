package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.RadiationEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class RadiationEffect2D implements IDisposable
   {
      
      private var radiationHelp:MovieClip;
      
      private var view:MapView2D;
      
      private var _targetShip:Ship;
      
      private var _effect:RadiationEffect;
      
      public function RadiationEffect2D(param1:MapView2D, param2:RadiationEffect)
      {
         super();
         this.view = param1;
         this._effect = param2;
         this._targetShip = this.map.hero;
         this._targetShip.position.changed.add(this.handleHeroPosChanged);
         this.updateRadiationHelp();
      }
      
      private function handleHeroPosChanged() : void
      {
         this.setRediationHelpPosition();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._targetShip.position.changed.remove(this.handleHeroPosChanged);
         if(this.radiationHelp)
         {
            TweenLite.to(this.radiationHelp,0.5,{
               "alpha":0,
               "onComplete":this.radiationHelp.parent.removeChild,
               "onCompleteParams":[this.radiationHelp]
            });
         }
      }
      
      private function radiationMcLoaded(param1:SWFFinisher) : void
      {
         this.radiationHelp = MovieClip(param1.getEmbeddedMovieClip("radiationHelp"));
         (this.radiationHelp["mask_mc"] as MovieClip).cacheAsBitmap = true;
         (this.radiationHelp["arrow_mc"] as MovieClip).cacheAsBitmap = true;
         (this.radiationHelp["arrow_mc"] as MovieClip).mask = this.radiationHelp["mask_mc"];
         this.radiationHelp.mouseEnabled = false;
         this.radiationHelp.mouseChildren = false;
         this.radiationHelp.x = ScreenManager.getHalfScreenWidth();
         this.radiationHelp.y = ScreenManager.getHalfScreenHeight();
         this.radiationHelp.rotation = this.calculateTargetRotation();
         this.view.addChildAt(this.radiationHelp,0);
         this.radiationHelp.alpha = 0;
         TweenLite.to(this.radiationHelp,1,{"alpha":0.2});
         this.updateRadiationHelp();
      }
      
      private function handleAssetLoadError() : void
      {
      }
      
      private function updateRadiationHelp() : void
      {
         if(this._effect.mapGroupsWithoutArrow.indexOf(Map.getGroupSystemMapName(this.map.mapID)) == -1)
         {
            if(this.radiationHelp == null)
            {
               GameFacade.getInstance().sendNotification(AssetNotifications.LOAD_ASSET,["ui",this.radiationMcLoaded,this.handleAssetLoadError,AssetsProxy.GAME]);
            }
            else
            {
               this.setRediationHelpPosition();
            }
         }
      }
      
      private function setRediationHelpPosition() : void
      {
         if(this.radiationHelp != null)
         {
            this.radiationHelp.x = ScreenManager.getHalfScreenWidth();
            this.radiationHelp.y = ScreenManager.getHalfScreenHeight();
            TweenLite.to(this.radiationHelp,0.1,{"shortRotation":{"rotation":this.calculateTargetRotation()}});
         }
      }
      
      private function calculateTargetRotation() : Number
      {
         var _loc1_:PointLite = null;
         if(this._targetShip.x >= 1000 && this._targetShip.x <= this.map.serious_width - 1000 && this._targetShip.y >= 1000 && this._targetShip.y <= this.map.serious_height - 1000)
         {
            _loc1_ = new PointLite(this.map.serious_width / 2,this.map.serious_height / 2);
         }
         else
         {
            _loc1_ = new PointLite(this.clamp(this._targetShip.x,1000,this.map.serious_width - 1000),this.clamp(this._targetShip.y,1000,this.map.serious_height - 1000));
         }
         return Math.atan2(_loc1_.y - this._targetShip.y,_loc1_.x - this._targetShip.x) * (360 / (2 * Math.PI));
      }
      
      private function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
   }
}

