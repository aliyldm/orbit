package spark.globalization.supportClasses
{
   import flash.globalization.Collator;
   import flash.globalization.CollatorMode;
   import flash.utils.getDefinitionByName;
   import mx.core.mx_internal;
   import mx.utils.ObjectUtil;
   import spark.globalization.LastOperationStatus;
   
   use namespace mx_internal;
   
   public class CollatorBase extends GlobalizationBase
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static const IGNORE_CASE:String = "ignoreCase";
      
      private static const IGNORE_CHARACTER_WIDTH:String = "ignoreCharacterWidth";
      
      private static const IGNORE_DIACRITICS:String = "ignoreDiacritics";
      
      private static const IGNORE_KANA_TYPE:String = "ignoreKanaType";
      
      private static const IGNORE_SYMBOLS:String = "ignoreSymbols";
      
      private static const NUMERIC_COMPARISON:String = "numericComparison";
      
      private var _g11nWorkingInstance:Collator;
      
      private var initialMode:String = null;
      
      public function CollatorBase(param1:String)
      {
         super();
         this.initialMode = param1;
      }
      
      public static function getAvailableLocaleIDNames() : Vector.<String>
      {
         var _loc1_:Vector.<String> = Collator.getAvailableLocaleIDNames();
         return _loc1_ ? _loc1_ : new Vector.<String>["en-US"]();
      }
      
      private function get g11nWorkingInstance() : Collator
      {
         if(!this._g11nWorkingInstance)
         {
            ensureStyleSource();
         }
         return this._g11nWorkingInstance;
      }
      
      private function set g11nWorkingInstance(param1:Collator) : void
      {
         this._g11nWorkingInstance = param1;
      }
      
      [Bindable("change")]
      override public function get actualLocaleIDName() : String
      {
         if(this.g11nWorkingInstance)
         {
            return this.g11nWorkingInstance.actualLocaleIDName;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return "en-US";
      }
      
      [Bindable("change")]
      override public function get lastOperationStatus() : String
      {
         return this.g11nWorkingInstance ? this.g11nWorkingInstance.lastOperationStatus : fallbackLastOperationStatus;
      }
      
      [Bindable("change")]
      override mx_internal function get useFallback() : Boolean
      {
         return this.g11nWorkingInstance == null;
      }
      
      [Bindable("change")]
      public function get ignoreCase() : Boolean
      {
         return getBasicProperty(properties,IGNORE_CASE);
      }
      
      public function set ignoreCase(param1:Boolean) : void
      {
         setBasicProperty(properties,IGNORE_CASE,param1);
      }
      
      [Bindable("change")]
      public function get ignoreCharacterWidth() : Boolean
      {
         return getBasicProperty(properties,IGNORE_CHARACTER_WIDTH);
      }
      
      public function set ignoreCharacterWidth(param1:Boolean) : void
      {
         setBasicProperty(properties,IGNORE_CHARACTER_WIDTH,param1);
      }
      
      [Bindable("change")]
      public function get ignoreDiacritics() : Boolean
      {
         return getBasicProperty(properties,IGNORE_DIACRITICS);
      }
      
      public function set ignoreDiacritics(param1:Boolean) : void
      {
         setBasicProperty(properties,IGNORE_DIACRITICS,param1);
      }
      
      [Bindable("change")]
      public function get ignoreKanaType() : Boolean
      {
         return getBasicProperty(properties,IGNORE_KANA_TYPE);
      }
      
      public function set ignoreKanaType(param1:Boolean) : void
      {
         setBasicProperty(properties,IGNORE_KANA_TYPE,param1);
      }
      
      [Bindable("change")]
      public function get ignoreSymbols() : Boolean
      {
         return getBasicProperty(properties,IGNORE_SYMBOLS);
      }
      
      public function set ignoreSymbols(param1:Boolean) : void
      {
         setBasicProperty(properties,IGNORE_SYMBOLS,param1);
      }
      
      [Bindable("change")]
      public function get numericComparison() : Boolean
      {
         return getBasicProperty(properties,NUMERIC_COMPARISON);
      }
      
      public function set numericComparison(param1:Boolean) : void
      {
         setBasicProperty(properties,NUMERIC_COMPARISON,param1);
      }
      
      override mx_internal function createWorkingInstance() : void
      {
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            this.g11nWorkingInstance = null;
            properties = null;
            return;
         }
         if(enforceFallback)
         {
            this.fallbackInstantiate();
            this.g11nWorkingInstance = null;
            return;
         }
         this.g11nWorkingInstance = new Collator(localeStyle,this.initialMode);
         if(Boolean(this.g11nWorkingInstance) && this.g11nWorkingInstance.lastOperationStatus != LastOperationStatus.UNSUPPORTED_ERROR)
         {
            properties = this.g11nWorkingInstance;
            propagateBasicProperties(this.g11nWorkingInstance);
            return;
         }
         this.fallbackInstantiate();
         this.g11nWorkingInstance = null;
         if(fallbackLastOperationStatus == LastOperationStatus.NO_ERROR)
         {
            fallbackLastOperationStatus = LastOperationStatus.USING_FALLBACK_WARNING;
         }
      }
      
      [Bindable("change")]
      public function compare(param1:String, param2:String) : int
      {
         if(this.g11nWorkingInstance)
         {
            if(param1 === null && param2 === null)
            {
               return 0;
            }
            if(param1 === null)
            {
               return 1;
            }
            if(param2 === null)
            {
               return -1;
            }
            return this.g11nWorkingInstance.compare(param1,param2);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return ObjectUtil.stringCompare(param1,param2,properties.ignoreCase);
      }
      
      [Bindable("change")]
      public function equals(param1:String, param2:String) : Boolean
      {
         if(this.g11nWorkingInstance)
         {
            if(param1 === null && param2 === null)
            {
               return true;
            }
            if(param1 === null || param2 === null)
            {
               return false;
            }
            return this.g11nWorkingInstance.equals(param1,param2);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return ObjectUtil.stringCompare(param1,param2,properties.ignoreCase) == 0;
      }
      
      private function fallbackInstantiate() : void
      {
         var _loc1_:Boolean = this.initialMode == CollatorMode.MATCHING || this.initialMode == CollatorMode.SORTING;
         fallbackLastOperationStatus = _loc1_ ? LastOperationStatus.NO_ERROR : LastOperationStatus.INVALID_ATTR_VALUE;
         properties = {
            "ignoreCase":this.initialMode == CollatorMode.MATCHING,
            "ignoreCharacterWidth":false,
            "ignoreDiacritics":false,
            "ignoreKanaType":false,
            "ignoreSymbols":false,
            "numericComparison":false
         };
         propagateBasicProperties(properties);
      }
   }
}

