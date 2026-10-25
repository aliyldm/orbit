package net.bigpoint.darkorbit.mvc.sectorControl.view
{
   import com.greensock.TweenLite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.mvc.map.MapNotification;
   import net.bigpoint.darkorbit.mvc.sectorControl.SectorControlNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControl.controller.CreateSectorControlUiCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.vo.SectorCapturingProgressBarStateVO;
   import net.bigpoint.darkorbit.mvc.sectorControl.view.components.SectorControlProgressBar;
   import net.bigpoint.darkorbit.net.HeroNotifications;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class SectorControlProgressBarMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "SectorControlProgressBarMediator";
      
      private var lastBarFactionID:int = -1;
      
      private var lastBorderFactionID:int = -1;
      
      public function SectorControlProgressBarMediator(param1:SectorControlProgressBar)
      {
         super(NAME,param1);
      }
      
      private function get view() : SectorControlProgressBar
      {
         return getViewComponent() as SectorControlProgressBar;
      }
      
      override public function onRemove() : void
      {
         this.removeView();
         super.onRemove();
         facade.registerCommand(SectorControlNotifications.INIT,CreateSectorControlUiCommand);
      }
      
      private function removeView() : void
      {
         if(Boolean(this.view) && Boolean(this.view.parent))
         {
            this.view.parent.removeChild(this.view);
         }
      }
      
      override public function setViewComponent(param1:Object) : void
      {
         this.removeView();
         super.setViewComponent(param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [SectorControlNotifications.UPDATE_PROGRESS_BAR_VIEW,MapNotification.CLEANUP,HeroNotifications.HERO_DIED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:SectorCapturingProgressBarStateVO = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         switch(param1.getName())
         {
            case SectorControlNotifications.UPDATE_PROGRESS_BAR_VIEW:
               _loc2_ = param1.getBody() as SectorCapturingProgressBarStateVO;
               if(this.lastBarFactionID != _loc2_.faction)
               {
                  this.view.changeBarFactionTo(_loc2_.faction);
                  this.lastBarFactionID = _loc2_.faction;
               }
               _loc3_ = FactionModule.FACTION_NONE;
               if(_loc2_.progress >= 100)
               {
                  _loc3_ = _loc2_.faction;
               }
               if(this.lastBorderFactionID != _loc3_)
               {
                  this.view.changeBorderFactionTo(_loc3_);
                  this.lastBorderFactionID = _loc3_;
               }
               _loc4_ = "";
               switch(_loc2_.direction)
               {
                  case SectorCapturingProgressBarStateVO.DIRECTION_NEUTRALIZING:
                     if(_loc2_.progress < 100)
                     {
                        _loc4_ = BPLocale.getItem("sectorcontrol_progressbar_neutralizing_capitals");
                     }
                     break;
                  case SectorCapturingProgressBarStateVO.DIRECTION_CAPTURING:
                     if(_loc2_.progress > 0)
                     {
                        _loc4_ = BPLocale.getItem("sectorcontrol_progressbar_conquering_capitals");
                     }
                     break;
                  default:
                     _loc4_ = "";
               }
               this.view.text.text = _loc4_;
               _loc5_ = _loc2_.participatingSector != null;
               if(_loc5_)
               {
                  TweenLite.to(this.view.bar,0.5,{
                     "scaleX":_loc2_.progress / 100,
                     "onComplete":this.setViewVisibilityHelper,
                     "onCompleteParams":[_loc5_]
                  });
               }
               else
               {
                  TweenLite.to(this.view.bar,0.5,{"scaleX":_loc2_.progress / 100});
                  this.setViewVisibilityHelper(_loc5_);
               }
               break;
            case MapNotification.CLEANUP:
            case HeroNotifications.HERO_DIED:
               this.setViewVisibilityHelper(false);
         }
      }
      
      private function setViewVisibilityHelper(param1:Boolean) : void
      {
         this.view.visible = param1;
      }
   }
}

