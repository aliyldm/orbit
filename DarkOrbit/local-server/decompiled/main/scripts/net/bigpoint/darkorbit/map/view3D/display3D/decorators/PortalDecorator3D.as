package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.env.Portal;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   
   public class PortalDecorator3D implements IMapUberAssetDecorator3D, IDisposable
   {
      
      private var _trait:UberDisplayTrait;
      
      private var _portal:Portal;
      
      private var _viewOwner:UberAsset3D;
      
      private var _timeout:uint;
      
      public function PortalDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._trait = param1;
         this._viewOwner = param2;
         this._portal = param1.owner as Portal;
      }
      
      public function decorate() : void
      {
         if(this._portal)
         {
            this._portal.jumped.add(this.startJumpAnimation);
         }
         if(ScreenManager.getInstance().map.lifeTime > 10000)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PORTAL_DONE,false,false,this._portal.x,this._portal.y);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._portal)
         {
            this._portal.jumped.remove(this.startJumpAnimation);
         }
         clearTimeout(this._timeout);
      }
      
      private function startJumpAnimation(param1:Number = 0) : void
      {
         clearTimeout(this._timeout);
         this._viewOwner.playAnimation("jump");
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PORTAL_JUMP,false,false,this._portal.x,this._portal.y);
         if(param1 > 0)
         {
            this._timeout = setTimeout(this._viewOwner.stopCurrentAnimation,param1 * 1000);
         }
      }
   }
}

