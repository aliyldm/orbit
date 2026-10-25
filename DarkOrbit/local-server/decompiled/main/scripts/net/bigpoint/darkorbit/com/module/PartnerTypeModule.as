package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PartnerTypeModule implements IModule
   {
      
      private static var _instance:PartnerTypeModule;
      
      public static const PARTNERTYPE_ANTEC:int = 0;
      
      public static const PARTNERTYPE_DARKORBIT:int = 1;
      
      public static const PARTNERTYPE_RAZER:int = 2;
      
      public static const PARTNERTYPE_ROCCAT:int = 3;
      
      public static const PARTNERTYPE_FROST:int = 4;
      
      public static const PARTNERTYPE__MAX:int = 5;
      
      public var typeValue:int = 0;
      
      public function PartnerTypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : PartnerTypeModule
      {
         return _instance || (_instance = new PartnerTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3261;
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
         param1.writeShort(3261);
         param1.writeShort(this.typeValue);
      }
   }
}

