package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ActivePerkModule implements IModule
   {
      
      private static var _instance:ActivePerkModule;
      
      public var modifierValue:Number = 0;
      
      public var perkTypeId:String = "";
      
      public function ActivePerkModule(param1:String = "", param2:Number = 0)
      {
         super();
         this.modifierValue = param2;
         this.perkTypeId = param1;
      }
      
      public static function get instance() : ActivePerkModule
      {
         return _instance || (_instance = new ActivePerkModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8215;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.modifierValue = param1.readFloat();
         this.perkTypeId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8215);
         param1.writeFloat(this.modifierValue);
         param1.writeUTF(this.perkTypeId);
      }
   }
}

