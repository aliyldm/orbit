package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttributeSkillRepairUpdateCommand implements IModule
   {
      
      private static var _instance:AttributeSkillRepairUpdateCommand;
      
      public var repairSkillMaxed:Boolean = false;
      
      public function AttributeSkillRepairUpdateCommand(param1:Boolean = false)
      {
         super();
         this.repairSkillMaxed = param1;
      }
      
      public static function get instance() : AttributeSkillRepairUpdateCommand
      {
         return _instance || (_instance = new AttributeSkillRepairUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 102;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.repairSkillMaxed = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(102);
         param1.writeBoolean(this.repairSkillMaxed);
      }
   }
}

