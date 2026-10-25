package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.SettingsWindowDecorator;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class CheckBoxComponent extends SimpleElement
   {
      
      public static const TYPE_AUTOSTART:int = 27;
      
      public var typeID:int;
      
      public var key:String;
      
      public var isAdvanced:Boolean;
      
      private var textField:TextField;
      
      private var guiManager:GuiManager;
      
      private var icon:MovieClip;
      
      private var tooltipKey:String;
      
      public function CheckBoxComponent(param1:int, param2:String, param3:GuiManager, param4:String = "", param5:Boolean = false)
      {
         super(SimpleElement.TYPE_CHECKBOX);
         this.typeID = param1;
         this.key = param2;
         this.guiManager = param3;
         this.isAdvanced = param5;
         this.tooltipKey = param4;
         this.init();
      }
      
      public static function convertFrameToBool(param1:int) : String
      {
         if(param1 == 1)
         {
            return "0";
         }
         return "1";
      }
      
      private function init() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:ToolTipHook = null;
         this.icon = ResourceManager.getMovieClip("ui","checkBox");
         this.icon.gotoAndStop(1);
         this.icon.buttonMode = true;
         var _loc1_:Function = this.handleCheckboxClick;
         if(this.typeID == TYPE_AUTOSTART)
         {
            _loc1_ = this.handleAutostartChange;
         }
         this.icon.addEventListener(MouseEvent.CLICK,_loc1_);
         this.addChild(this.icon);
         this.textField = new TextField();
         this.textField.defaultTextFormat = Styles.logFmt;
         this.textField.embedFonts = Styles.logEmbed;
         this.textField.text = BPLocale.getItem(this.key);
         this.textField.border = false;
         this.textField.selectable = false;
         this.textField.autoSize = TextFieldAutoSize.LEFT;
         this.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.textField.height = Styles.logFontHeight + 5;
         this.textField.x = this.icon.width + 5;
         this.textField.addEventListener(MouseEvent.CLICK,_loc1_);
         this.addChild(this.textField);
         if(this.tooltipKey != "")
         {
            _loc2_ = new Sprite();
            _loc2_.addChild(SWFFinisher(ResourceManager.fileCollection.getFinisher("icons")).getEmbeddedBitmap("general_help"));
            _loc2_.x = this.textField.x + this.textField.width + 5;
            _loc2_.y = this.textField.y;
            this.addChild(_loc2_);
            _loc3_ = TooltipControl.getInstance().addToolTip(_loc2_,BPLocale.getItem(this.tooltipKey));
            _loc3_.showImmediately = true;
         }
         this.resetSetting();
      }
      
      public function switchChecked(param1:int) : void
      {
         var _loc2_:int = param1 == 1 ? 2 : 1;
         this.icon.gotoAndStop(_loc2_);
      }
      
      public function setSetting() : void
      {
         SettingsWindowDecorator.setSettableSettingValue(this.typeID,convertFrameToBool(this.icon.currentFrame));
      }
      
      public function resetSetting() : void
      {
         var _loc1_:Boolean = SettingsWindowDecorator.getCheckBoxSettingValue(this.typeID);
         var _loc2_:int = _loc1_ ? 2 : 1;
         this.icon.gotoAndStop(_loc2_);
      }
      
      private function handleAutostartChange(param1:MouseEvent) : void
      {
         if(this.icon.currentFrame == 1)
         {
            this.guiManager.createAutoStartWarning();
         }
         this.handleCheckboxClick();
      }
      
      private function handleCheckboxClick(param1:MouseEvent = null) : void
      {
         if(this.icon.currentFrame == 1)
         {
            this.icon.gotoAndStop(2);
         }
         else
         {
            this.icon.gotoAndStop(1);
         }
      }
      
      public function getType() : int
      {
         return this.typeID;
      }
      
      public function getIcon() : MovieClip
      {
         return this.icon;
      }
      
      public function show(param1:Boolean) : void
      {
         this.visible = param1;
      }
   }
}

