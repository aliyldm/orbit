package net.bigpoint.darkorbit.mvc.hints.view
{
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.hints.HintsConstants;
   import net.bigpoint.darkorbit.mvc.hints.HintsNotifications;
   import net.bigpoint.darkorbit.mvc.hints.view.effects.FadeOutWithDelayEffect;
   import net.bigpoint.darkorbit.mvc.hints.view.effects.interfaces.IShowHideEffect;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HintsMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "HintsMediator";
      
      private static const RESKEY:String = "hints";
      
      private var _hint:Sprite;
      
      public function HintsMediator(param1:Sprite)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [HintsNotifications.SHOW_HINT,HintsNotifications.HIDE_HINT,HintsNotifications.CENTER_HINTS];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = String(param1.getBody());
         switch(param1.getName())
         {
            case HintsNotifications.SHOW_HINT:
               this.showHint(_loc2_);
               break;
            case HintsNotifications.HIDE_HINT:
               this.hideHint(_loc2_);
               break;
            case HintsNotifications.CENTER_HINTS:
               this.centerHint();
         }
      }
      
      private function showHint(param1:String) : void
      {
         if(!assetsProxy.isLoaded(RESKEY))
         {
            assetsProxy.loadAndCall(RESKEY,this.showHint,arguments);
            return;
         }
         var _loc3_:SWFFinisher = ResourceManager.fileCollection.getFinisher(RESKEY) as SWFFinisher;
         this._hint = _loc3_.getEmbeddedMovieClip(param1);
         this._hint.alpha = 0;
         this._hint.visible = false;
         this._hint.mouseChildren = false;
         this._hint.mouseEnabled = false;
         this.view.addChild(this._hint);
         this.centerHint();
         var _loc4_:IShowHideEffect = this.getShowHideEffect(param1);
         _loc4_.show(this._hint);
      }
      
      private function getShowHideEffect(param1:String) : IShowHideEffect
      {
         var _loc2_:String = HintsConstants.EFFECTS_MAP[param1];
         switch(_loc2_)
         {
            case HintsConstants.SHOW_AND_HIDE_WITH_DELAY:
         }
         return new FadeOutWithDelayEffect();
      }
      
      private function hideHint(param1:String) : void
      {
         var _loc2_:IShowHideEffect = this.getShowHideEffect(param1);
         _loc2_.hide(this._hint,this.onHideCompleteCallback);
      }
      
      private function onHideCompleteCallback() : void
      {
         if(Boolean(this._hint) && this.view.contains(this._hint))
         {
            this.view.removeChild(this._hint);
         }
      }
      
      private function centerHint() : void
      {
         if(this._hint)
         {
            this._hint.y = 136;
            this._hint.x = ScreenManager.getHalfScreenWidth() - this._hint.width * 0.5;
         }
      }
      
      private function get view() : Sprite
      {
         return viewComponent as Sprite;
      }
   }
}

