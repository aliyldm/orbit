package net.bigpoint.darkorbit.mvc.sectorControl.view
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.com.module.BoostedAttributeTypeModule;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.map.MapNotification;
   import net.bigpoint.darkorbit.mvc.sectorControl.SectorControlNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControl.controller.CreateSectorControlUiCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.view.components.SectorControlUi;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SectorControlUiMediator extends DOAbstractMediator implements IMediator
   {
      
      public static const NAME:String = "SectorControlUiMediator";
      
      public function SectorControlUiMediator(param1:SectorControlUi)
      {
         super(NAME,param1);
         this.addEventListeners();
      }
      
      private function addEventListeners() : void
      {
         var _loc1_:SimpleWindow = guiManager.getWindow(GuiConstants.SECTOR_CONTROL_WINDOW);
         if(_loc1_)
         {
            _loc1_.addEventListener(SimpleWindowEvent.ON_CLOSE,this.handleOnClose);
         }
      }
      
      private function removeEventListeners() : void
      {
         var _loc1_:SimpleWindow = guiManager.getWindow(GuiConstants.SECTOR_CONTROL_WINDOW);
         if(_loc1_)
         {
            _loc1_.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.handleOnClose);
         }
      }
      
      private function handleOnClose(param1:SimpleWindowEvent) : void
      {
         this.remove();
      }
      
      private function remove() : void
      {
         this.removeEventListeners();
         facade.removeMediator(getMediatorName());
         this.onRemove();
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
         return [MapNotification.CLEANUP,SectorControlNotifications.BLEED,SectorControlNotifications.FACTION_TICKETS_MODEL_CHANGED,SectorControlNotifications.FACTION_PLAYER_COUNTS_MODEL_CHANGED,SectorControlNotifications.FACTION_CONTROL_POINT_BONUSSES_MODEL_CHANGED];
      }
      
      private function get view() : SectorControlUi
      {
         return viewComponent as SectorControlUi;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case SectorControlNotifications.BLEED:
               this.view.bleed(param1.getBody() as PointLite);
               break;
            case SectorControlNotifications.FACTION_TICKETS_MODEL_CHANGED:
               this.updateTickets(param1.getBody() as Vector.<PointLite>);
               break;
            case SectorControlNotifications.FACTION_PLAYER_COUNTS_MODEL_CHANGED:
               this.updatePlayerCounts(param1.getBody() as Vector.<PointLite>);
               break;
            case SectorControlNotifications.FACTION_CONTROL_POINT_BONUSSES_MODEL_CHANGED:
               this.updateToolTip(param1.getBody() as Vector.<Dictionary>);
               break;
            case MapNotification.CLEANUP:
               this.remove();
         }
      }
      
      private function updateTickets(param1:Vector.<PointLite>) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 1;
         while(_loc3_ < _loc2_)
         {
            if(this.view.ticketBarComponents.length - 1 >= _loc3_)
            {
               this.view.ticketBarComponents[_loc3_].update(param1[_loc3_].x,param1[_loc3_].y);
               this.view.ticketTextElements[_loc3_].textField.text = param1[_loc3_].x.toString();
            }
            _loc3_++;
         }
      }
      
      private function updatePlayerCounts(param1:Vector.<PointLite>) : void
      {
         var _loc2_:Vector.<PointLite> = param1;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 1;
         while(_loc4_ < _loc3_)
         {
            if(this.view.playerAmountTextElements.length - 1 >= _loc4_)
            {
               this.view.playerAmountTextElements[_loc4_].textField.text = _loc2_[_loc4_].x.toString();
               if(_loc2_[_loc4_].x < 5)
               {
                  this.view.playerAmountTextElements[_loc4_].textField.textColor = Styles.sectorControlPlayerAmountsRed;
               }
               else
               {
                  this.view.playerAmountTextElements[_loc4_].textField.textColor = Styles.sectorControlPlayerAmountsGrey;
               }
               this.view.maxPlayerAmountTextElements[_loc4_].textField.text = "/" + _loc2_[_loc4_].y.toString();
            }
            _loc4_++;
         }
      }
      
      private function updateToolTip(param1:Vector.<Dictionary>) : void
      {
         var _loc4_:SimpleElement = null;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:ToolTipHook = null;
         var _loc8_:TooltipControl = null;
         var _loc2_:Vector.<Dictionary> = param1;
         var _loc3_:int = int(this.view.cpBonusElements.length);
         _loc8_ = TooltipControl.getInstance();
         var _loc9_:int = 1;
         while(_loc9_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc9_] ? Number(_loc2_[_loc9_][BoostedAttributeTypeModule.ATTRIBUTETYPE_DAMAGE]) : NaN;
            _loc4_ = this.view.cpBonusElements[_loc9_] as SimpleElement;
            if(Boolean(_loc5_) && Boolean(!isNaN(_loc5_)) && _loc5_ > 0)
            {
               _loc4_.visible = true;
               _loc6_ = BPLocale.getItem("ttip_sectorcontrol_ingame_status_cp_bonusses").replace("%PERCENTAGE%",String(_loc5_));
               _loc7_ = _loc8_.getToolTipForObject(_loc4_);
               if(_loc7_)
               {
                  _loc7_.updateText(_loc6_);
               }
               else
               {
                  _loc8_.addToolTip(_loc4_,_loc6_);
               }
            }
            else
            {
               _loc8_.removeToolTip(_loc4_);
               _loc4_.visible = false;
            }
            _loc9_++;
         }
      }
   }
}

