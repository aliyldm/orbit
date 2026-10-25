package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReplacementTypeModule implements IModule
   {
      
      private static var _instance:ReplacementTypeModule;
      
      public static const REPLACEMENTTYPE_PLAIN:int = 0;
      
      public static const REPLACEMENTTYPE_LOOT_ID_CODE:int = 1;
      
      public static const REPLACEMENTTYPE_LOOT_ID_SHORT:int = 2;
      
      public static const REPLACEMENTTYPE_LOOT_ID_FULLNAME:int = 3;
      
      public static const REPLACEMENTTYPE_LOOT_ID_DESCRIPTION:int = 4;
      
      public static const REPLACEMENTTYPE_LOCALIZED:int = 5;
      
      public static const REPLACEMENTTYPE_MAP_ID:int = 6;
      
      public static const REPLACEMENTTYPE_LOOT_ID_TOOLTIP_DESCRIPTION:int = 7;
      
      public static const REPLACEMENTTYPE_LOOT_ID_SOURCE:int = 8;
      
      public static const REPLACEMENTTYPE__MAX:int = 9;
      
      public var typeValue:int = 0;
      
      public function ReplacementTypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : ReplacementTypeModule
      {
         return _instance || (_instance = new ReplacementTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19434;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.typeValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(19434);
         param1.writeShort(this.typeValue);
      }
   }
}

