package net.bigpoint.darkorbit.map.view2D.display.decorators.portal
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.env.Portal;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberMapAssetView2D;
   import net.bigpoint.darkorbit.mvc.display.IDOTextField;
   
   public class PortalDecorator2D implements IUpdatable, IDisposable, IMapUberAssetDecorator2D
   {
      
      private var _trait:UberDisplayTrait;
      
      private var _portal:Portal;
      
      private var _viewOwner:UberAsset2D;
      
      private var _label:PortalLabel;
      
      private var _kronos:KronosPortalDecorator;
      
      private var _portalView:UberMapAssetView2D;
      
      private var _stopJumpAnimationPointer:uint;
      
      public function PortalDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         var _loc4_:String = null;
         this._trait = param1;
         this._viewOwner = param2;
         this._portal = param1.owner as Portal;
         this._portalView = this._viewOwner.getViewElement("portalView") as UberMapAssetView2D;
         if(this._portalView)
         {
            if(this._portalView.view.getViewById("labelF") != null)
            {
               this._label = new PortalLabel(this._portalView.view.getViewById("labelF") as IDOTextField);
               _loc4_ = String(param3.xml.@displayTextKey);
               this._label.text = _loc4_ ? BPLocale.getItem(_loc4_) : " -- ";
            }
            if(this._portalView.view.getViewById("map_preview") != null)
            {
               this._kronos = new KronosPortalDecorator(this._portalView.view,param1.owner.position);
            }
            if(ScreenManager.getInstance().map.lifeTime > 10000)
            {
               this._portalView.view.startTween("spawn_animation");
               if(this._portal)
               {
                  AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PORTAL_DONE,false,false,this._portal.x,this._portal.y);
               }
            }
            else
            {
               this._portalView.view.startTween("spawn_no_animation");
            }
            if(this._portal)
            {
               this._portal.jumped.add(this.startJumpAnimation);
            }
            return;
         }
         throw new Error("no portalView");
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._portal.jumped.remove(this.startJumpAnimation);
         clearTimeout(this._stopJumpAnimationPointer);
         if(this._label)
         {
            this._label.disposeView();
         }
      }
      
      private function startJumpAnimation(param1:Number = 0) : void
      {
         if(this._portalView)
         {
            this._portalView.view.startTween("jumpOn");
         }
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PORTAL_JUMP,false,false,this._portal.x,this._portal.y);
         if(param1 > 0)
         {
            this._stopJumpAnimationPointer = setTimeout(this.stopJumpAnimation,param1 * 1000);
         }
      }
      
      private function stopJumpAnimation() : void
      {
         if(Boolean(this._portalView) && Boolean(this._portalView.view))
         {
            this._portalView.view.startTween("jumpOff");
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         if(this._kronos)
         {
            this._kronos.updateObj(param1);
         }
      }
   }
}

