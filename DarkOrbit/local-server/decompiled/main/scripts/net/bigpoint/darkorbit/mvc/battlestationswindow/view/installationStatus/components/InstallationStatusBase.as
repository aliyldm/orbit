package net.bigpoint.darkorbit.mvc.battlestationswindow.view.installationStatus.components
{
   import flash.text.TextField;
   import mx.controls.ProgressBar;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import spark.components.Button;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   public class InstallationStatusBase extends SkinnableContainer
   {
      
      private static const _tmpField:TextField = new TextField();
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1791483012titleLabel:Label;
      
      private var _1479129570yourClanProgressLabel:Label;
      
      private var _1469884261yourClanProgressValue:Label;
      
      private var _433102218yourClanProgress:ProgressBar;
      
      private var _1367921749leadingClanProgressLabel:Label;
      
      private var _1358676440leadingClanProgressValue:Label;
      
      private var _1087473463leadingClanProgress:ProgressBar;
      
      private var _784257572buildButtonDisabled:DOButtonBase;
      
      private var _1768148800buildButton:DOButtonBase;
      
      protected var _1254577033_yourClanModulesTipText:String;
      
      protected var _1065425150_leadingClanModulesTipText:String;
      
      private var _1717482413tipButton:Button;
      
      public function InstallationStatusBase()
      {
         super();
      }
      
      protected function creationCompleteHandler(param1:FlexEvent) : void
      {
         callLater(this.initLabels);
      }
      
      private function initLabels() : void
      {
         this.titleLabel.text = BPLocale.getItem("label_bswin_install_status");
         this.buildButtonDisabled.label = BPLocale.getItem("btn_bswin_build_station");
         this.buildButton.label = BPLocale.getItem("btn_bswin_build_station");
      }
      
      public function setData(param1:Number, param2:Number, param3:Boolean, param4:String, param5:String, param6:Boolean = false) : void
      {
         _tmpField.htmlText = param5;
         this.yourClanProgressLabel.text = _tmpField.text;
         _tmpField.htmlText = param4 || " ---";
         this.leadingClanProgressLabel.text = _tmpField.text;
         this.yourClanProgressValue.text = this.format(param1) + "%";
         this.yourClanProgress.setProgress(param1,1);
         this.leadingClanProgressValue.text = this.format(param2) + "%";
         this.leadingClanProgress.setProgress(param2,1);
         this.buildButton.visible = param3;
         this.buildButtonDisabled.visible = !param3;
         if(param6)
         {
            this.tipButton.visible = true;
            this.tipButton.toolTip = BPLocale.getItem("tooltip_no_rights_to_build");
            this.tipButton.alpha = 0;
         }
         else
         {
            this.tipButton.visible = false;
         }
         this.initTooltips(param1 * 10,param2 * 10,param4);
      }
      
      private function initTooltips(param1:int, param2:int, param3:String) : void
      {
         this._yourClanModulesTipText = BPLocale.getItem("tooltip_your_clans_modules_num").replace("%AMOUNT%",param1);
         if(param2 == 0)
         {
            this._leadingClanModulesTipText = "";
            this.leadingClanProgressLabel.toolTip = null;
            this.leadingClanProgressValue.toolTip = null;
         }
         else
         {
            this._leadingClanModulesTipText = BPLocale.getItem("tooltip_your_leading_modules_num");
            this._leadingClanModulesTipText = this._leadingClanModulesTipText.replace("%AMOUNT%",param2);
            this._leadingClanModulesTipText = this._leadingClanModulesTipText.replace("%CLAN_NAME%",param3);
         }
      }
      
      private function format(param1:Number) : int
      {
         return Math.round(Number(param1.toFixed(2)) * 100);
      }
      
      [Bindable(event="propertyChange")]
      public function get titleLabel() : Label
      {
         return this._1791483012titleLabel;
      }
      
      public function set titleLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1791483012titleLabel;
         if(_loc2_ !== param1)
         {
            this._1791483012titleLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get yourClanProgressLabel() : Label
      {
         return this._1479129570yourClanProgressLabel;
      }
      
      public function set yourClanProgressLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1479129570yourClanProgressLabel;
         if(_loc2_ !== param1)
         {
            this._1479129570yourClanProgressLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yourClanProgressLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get yourClanProgressValue() : Label
      {
         return this._1469884261yourClanProgressValue;
      }
      
      public function set yourClanProgressValue(param1:Label) : void
      {
         var _loc2_:Object = this._1469884261yourClanProgressValue;
         if(_loc2_ !== param1)
         {
            this._1469884261yourClanProgressValue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yourClanProgressValue",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get yourClanProgress() : ProgressBar
      {
         return this._433102218yourClanProgress;
      }
      
      public function set yourClanProgress(param1:ProgressBar) : void
      {
         var _loc2_:Object = this._433102218yourClanProgress;
         if(_loc2_ !== param1)
         {
            this._433102218yourClanProgress = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yourClanProgress",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leadingClanProgressLabel() : Label
      {
         return this._1367921749leadingClanProgressLabel;
      }
      
      public function set leadingClanProgressLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1367921749leadingClanProgressLabel;
         if(_loc2_ !== param1)
         {
            this._1367921749leadingClanProgressLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leadingClanProgressLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leadingClanProgressValue() : Label
      {
         return this._1358676440leadingClanProgressValue;
      }
      
      public function set leadingClanProgressValue(param1:Label) : void
      {
         var _loc2_:Object = this._1358676440leadingClanProgressValue;
         if(_loc2_ !== param1)
         {
            this._1358676440leadingClanProgressValue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leadingClanProgressValue",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leadingClanProgress() : ProgressBar
      {
         return this._1087473463leadingClanProgress;
      }
      
      public function set leadingClanProgress(param1:ProgressBar) : void
      {
         var _loc2_:Object = this._1087473463leadingClanProgress;
         if(_loc2_ !== param1)
         {
            this._1087473463leadingClanProgress = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leadingClanProgress",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buildButtonDisabled() : DOButtonBase
      {
         return this._784257572buildButtonDisabled;
      }
      
      public function set buildButtonDisabled(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._784257572buildButtonDisabled;
         if(_loc2_ !== param1)
         {
            this._784257572buildButtonDisabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buildButtonDisabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buildButton() : DOButtonBase
      {
         return this._1768148800buildButton;
      }
      
      public function set buildButton(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._1768148800buildButton;
         if(_loc2_ !== param1)
         {
            this._1768148800buildButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buildButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _yourClanModulesTipText() : String
      {
         return this._1254577033_yourClanModulesTipText;
      }
      
      protected function set _yourClanModulesTipText(param1:String) : void
      {
         var _loc2_:Object = this._1254577033_yourClanModulesTipText;
         if(_loc2_ !== param1)
         {
            this._1254577033_yourClanModulesTipText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_yourClanModulesTipText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _leadingClanModulesTipText() : String
      {
         return this._1065425150_leadingClanModulesTipText;
      }
      
      protected function set _leadingClanModulesTipText(param1:String) : void
      {
         var _loc2_:Object = this._1065425150_leadingClanModulesTipText;
         if(_loc2_ !== param1)
         {
            this._1065425150_leadingClanModulesTipText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_leadingClanModulesTipText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tipButton() : Button
      {
         return this._1717482413tipButton;
      }
      
      public function set tipButton(param1:Button) : void
      {
         var _loc2_:Object = this._1717482413tipButton;
         if(_loc2_ !== param1)
         {
            this._1717482413tipButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tipButton",_loc2_,param1));
            }
         }
      }
   }
}

