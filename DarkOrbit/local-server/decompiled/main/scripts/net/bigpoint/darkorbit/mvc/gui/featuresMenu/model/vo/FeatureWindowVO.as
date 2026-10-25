package net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.com.module.MessageKeyListWildcardCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.utils.BPLocaleUtils;
   
   public class FeatureWindowVO
   {
      
      private var _id:String;
      
      private var _titleTextKey:String;
      
      private var _position:PointLite;
      
      private var _size:PointLite;
      
      private var _definition:FeatureWindowDefinitionVO;
      
      private var _helpText:MessageKeyListWildcardCommand;
      
      private var _toolTip:MessageKeyListWildcardCommand;
      
      private var _maximized:Boolean;
      
      private var _toggleMaximize:Boolean = false;
      
      private var _maximizedChanged:Boolean = false;
      
      private var _saveSettingsOnServer:Boolean = false;
      
      private var _minimizedPosition:Point;
      
      private var _showOnTop:Boolean;
      
      public function FeatureWindowVO(param1:String, param2:String, param3:PointLite, param4:PointLite, param5:Boolean, param6:FeatureWindowDefinitionVO, param7:MessageKeyListWildcardCommand = null, param8:MessageKeyListWildcardCommand = null, param9:Boolean = false)
      {
         super();
         this._id = param1;
         this._titleTextKey = param2;
         this._position = param3;
         this._size = param4;
         this._definition = param6;
         this._helpText = param7;
         this._toolTip = param8;
         this._maximized = param5;
         this._showOnTop = param9;
      }
      
      public function toString() : String
      {
         return this._id;
      }
      
      public function update(param1:PointLite, param2:PointLite, param3:Boolean, param4:String = null, param5:MessageKeyListWildcardCommand = null, param6:MessageKeyListWildcardCommand = null) : void
      {
         this._position = param1;
         if(this._id != "expedition" && this._id != GuiConstants.SPACE_SEARCH && this._id != GuiConstants.DISPATCH && this._id != GuiConstants.GG_BUILDER_WINDOW && this._definition.resizable)
         {
            this._size = param2;
         }
         this._maximizedChanged = this._maximized != param3;
         this._maximized = param3;
         if(Boolean(param4) && BPLocaleUtils.hasTranslation(param4))
         {
            this._titleTextKey = param4;
         }
         if(param5)
         {
            this._helpText = param5;
         }
         if(param6)
         {
            this._toolTip = param6;
         }
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get titleTextKey() : String
      {
         return this._titleTextKey;
      }
      
      public function get helpText() : MessageKeyListWildcardCommand
      {
         return this._helpText;
      }
      
      public function get toolTip() : MessageKeyListWildcardCommand
      {
         return this._toolTip;
      }
      
      public function get maximized() : Boolean
      {
         return this._maximized;
      }
      
      public function set maximized(param1:Boolean) : void
      {
         this._maximizedChanged = this._maximized != param1;
         this._maximized = param1;
      }
      
      public function get definition() : FeatureWindowDefinitionVO
      {
         return this._definition;
      }
      
      public function get saveSettingsOnServer() : Boolean
      {
         return this._saveSettingsOnServer;
      }
      
      public function set saveSettingsOnServer(param1:Boolean) : void
      {
         this._saveSettingsOnServer = param1;
      }
      
      public function get position() : PointLite
      {
         return this._position;
      }
      
      public function get size() : PointLite
      {
         return this._size;
      }
      
      public function set size(param1:PointLite) : void
      {
         this._size = param1;
      }
      
      public function get minimizedPosition() : Point
      {
         return this._minimizedPosition;
      }
      
      public function set minimizedPosition(param1:Point) : void
      {
         this._minimizedPosition = param1;
      }
      
      public function get toggleMaximize() : Boolean
      {
         return this._toggleMaximize;
      }
      
      public function set toggleMaximize(param1:Boolean) : void
      {
         this._toggleMaximize = param1;
      }
      
      public function get maximixedChanged() : Boolean
      {
         return this._maximizedChanged;
      }
      
      public function get showOnTop() : Boolean
      {
         return this._showOnTop;
      }
      
      public function set showOnTop(param1:Boolean) : void
      {
         this._showOnTop = param1;
      }
   }
}

