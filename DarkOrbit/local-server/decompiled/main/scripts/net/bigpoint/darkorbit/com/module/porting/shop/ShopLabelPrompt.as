package net.bigpoint.darkorbit.com.module.porting.shop
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShopLabelPrompt implements IModule
   {
      
      private static var _instance:ShopLabelPrompt;
      
      public static const PROMPTTYPE_PROMPT_NONE:int = 0;
      
      public static const PROMPTTYPE_PROMPT_DISCOUNTS:int = 1;
      
      public static const PROMPTTYPE_PROMPT_ACTIVITY:int = 2;
      
      public static const PROMPTTYPE_PROMPT_DISCOUNTS_AND_ACTIVITY:int = 3;
      
      public static const PROMPTTYPE__MAX:int = 4;
      
      public var category:String = "";
      
      public var promptType:int = 0;
      
      public function ShopLabelPrompt(param1:String = "", param2:int = 0)
      {
         super();
         this.category = param1;
         this.promptType = param2;
      }
      
      public static function get instance() : ShopLabelPrompt
      {
         return _instance || (_instance = new ShopLabelPrompt());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11977;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.category = param1.readUTF();
         this.promptType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11977);
         param1.writeUTF(this.category);
         param1.writeShort(this.promptType);
      }
   }
}

