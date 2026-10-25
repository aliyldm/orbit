package net.bigpoint.darkorbit.mvc.sectorControl.view.components
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.windows.components.BarComponent;
   import net.bigpoint.darkorbit.gui.windows.components.BarConfigVO;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlConstants;
   
   public class SectorControlUi extends Sprite
   {
      
      public var ticketBarComponents:Vector.<BarComponent> = new Vector.<BarComponent>();
      
      public var ticketTextElements:Vector.<TextFieldElement> = new Vector.<TextFieldElement>();
      
      public var playerAmountTextElements:Vector.<TextFieldElement> = new Vector.<TextFieldElement>();
      
      public var maxPlayerAmountTextElements:Vector.<TextFieldElement> = new Vector.<TextFieldElement>();
      
      public var cpBonusElements:Vector.<SimpleElement> = new Vector.<SimpleElement>();
      
      public function SectorControlUi()
      {
         super();
         ResourceManager.lazyGetAsset(SectorControlConstants.LIBRARY_NAME,this.createSimpleWindow,new Function());
      }
      
      public function reinit() : void
      {
         ResourceManager.lazyGetAsset(SectorControlConstants.LIBRARY_NAME,this.createSimpleWindow,new Function());
      }
      
      private function createSimpleWindow(param1:SWFFinisher) : void
      {
         var _loc4_:SimpleContainer = null;
         var _loc6_:int = 0;
         var _loc7_:Bitmap = null;
         var _loc8_:BarConfigVO = null;
         var _loc9_:BarComponent = null;
         var _loc10_:TextFormat = null;
         var _loc11_:TextFormat = null;
         var _loc12_:TextFieldElement = null;
         var _loc13_:TextFieldElement = null;
         var _loc14_:TextFieldElement = null;
         var _loc15_:SimpleElement = null;
         if(ScreenManager.getInstance().map == null)
         {
            return;
         }
         var _loc2_:GuiManager = GuiManager.instance;
         var _loc3_:SimpleWindow = (_loc2_.getWindow(GuiConstants.SECTOR_CONTROL_WINDOW) || _loc2_.createWindow(GuiConstants.SECTOR_CONTROL_WINDOW)) as SimpleWindow;
         _loc4_ = new SimpleContainer(_loc2_,SimpleContainer.CLASS_SECTOR_CONTROL);
         var _loc5_:int = 0;
         _loc4_.x = 12;
         _loc4_.y = 35;
         this.ticketBarComponents.length = 4;
         this.ticketTextElements.length = 4;
         this.playerAmountTextElements.length = 4;
         this.maxPlayerAmountTextElements.length = 4;
         this.cpBonusElements.length = 4;
         _loc6_ = 1;
         while(_loc6_ <= 3)
         {
            _loc7_ = param1.getEmbeddedBitmap("logo" + InGameCatalog.instance.factions_names[_loc6_]);
            _loc8_ = new BarConfigVO();
            _loc8_.backgroundColor = Styles.sectorControlTicketAmountsBgGrey;
            _loc8_.solidBackground = false;
            _loc8_.flashType = BarConfigVO.FLASH_TYPE_SECTOR_CONTROL;
            _loc8_.barColor = InGameCatalog.getInstance().factions_colours[_loc6_];
            _loc9_ = new BarComponent(0,_loc7_,_loc8_);
            _loc9_.removeBarClickability();
            _loc9_.y = _loc5_;
            _loc9_.setSize(100,6);
            _loc4_.addElement(_loc9_);
            this.ticketBarComponents[_loc6_] = _loc9_;
            _loc10_ = Styles.sectorControlTicketAmountsFmt;
            _loc11_ = new TextFormat(_loc10_.font,_loc10_.size,InGameCatalog.getInstance().factions_colours[_loc6_],_loc10_.bold,_loc10_.italic,_loc10_.underline,_loc10_.url,_loc10_.target,_loc10_.align);
            _loc12_ = new TextFieldElement(40,40,_loc11_,"?",TextFormatAlign.LEFT);
            _loc12_.y = _loc5_ - 4;
            _loc12_.x = _loc9_.x + _loc7_.width + 5;
            _loc4_.addElement(_loc12_);
            this.ticketTextElements[_loc6_] = _loc12_;
            TooltipControl.getInstance().addToolTip(this.ticketBarComponents[_loc6_],BPLocale.getItem("ttip_sectorcontrol_ingame_status_tickets").replace("%FACTION%",InGameCatalog.getInstance().factions_names[_loc6_]));
            TooltipControl.getInstance().addToolTip(this.ticketTextElements[_loc6_],BPLocale.getItem("ttip_sectorcontrol_ingame_status_tickets").replace("%FACTION%",InGameCatalog.getInstance().factions_names[_loc6_]));
            _loc13_ = new TextFieldElement(30,40,Styles.sectorControlPlayerAmountsFmt,"?",TextFormatAlign.RIGHT);
            _loc13_.y = _loc5_;
            _loc13_.x = 118;
            _loc4_.addElement(_loc13_);
            this.playerAmountTextElements[_loc6_] = _loc13_;
            _loc14_ = new TextFieldElement(40,40,Styles.sectorControlPlayerAmountsFmt,"/?",TextFormatAlign.LEFT);
            _loc14_.y = _loc5_;
            _loc14_.x = 145;
            _loc4_.addElement(_loc14_);
            this.maxPlayerAmountTextElements[_loc6_] = _loc14_;
            TooltipControl.getInstance().addToolTip(this.playerAmountTextElements[_loc6_],BPLocale.getItem("ttip_sectorcontrol_ingame_status_players"));
            TooltipControl.getInstance().addToolTip(this.maxPlayerAmountTextElements[_loc6_],BPLocale.getItem("ttip_sectorcontrol_ingame_status_players"));
            _loc15_ = new SimpleElement(SimpleElement.TYPE_SECTOR_CONTROL_DAMAGE_BONUS);
            _loc15_.y = _loc5_;
            _loc15_.addChild(param1.getEmbeddedBitmap("damageBonusIcon"));
            _loc15_.x = 180;
            _loc15_.visible = false;
            _loc4_.addElement(_loc15_);
            this.cpBonusElements[_loc6_] = _loc15_;
            _loc5_ += _loc7_.height + 10;
            _loc6_++;
         }
         _loc3_.addContainer(_loc4_);
         _loc3_.maximize();
      }
      
      public function bleed(param1:PointLite) : void
      {
         var _loc2_:int = param1.x;
         var _loc3_:Number = Math.min(param1.y,5) / 2;
         if(this.ticketBarComponents.length > _loc2_)
         {
            this.ticketBarComponents[_loc2_].pulseTheBar(_loc3_,0.2 / _loc3_);
         }
      }
   }
}

