package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetLevelUpdateCommand implements IModule
   {
      
      private static var _instance:PetLevelUpdateCommand;
      
      public var petLevel:int = 0;
      
      public var petExperiencePointsUntilNextLevel:Number = 0;
      
      public var designId:int = 0;
      
      public var expansionStage:int = 0;
      
      public function PetLevelUpdateCommand(param1:int = 0, param2:Number = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.petLevel = param1;
         this.petExperiencePointsUntilNextLevel = param2;
         this.designId = param3;
         this.expansionStage = param4;
      }
      
      public static function get instance() : PetLevelUpdateCommand
      {
         return _instance || (_instance = new PetLevelUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 160;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.petLevel = param1.readShort();
         this.petLevel = 0xFFFF & ((0xFFFF & this.petLevel) << 14 % 16 | (0xFFFF & this.petLevel) >>> 16 - 14 % 16);
         this.petLevel = this.petLevel > 32767 ? int(this.petLevel - 65536) : this.petLevel;
         this.petExperiencePointsUntilNextLevel = param1.readDouble();
         this.designId = param1.readShort();
         this.designId = 0xFFFF & ((0xFFFF & this.designId) >>> 16 % 16 | (0xFFFF & this.designId) << 16 - 16 % 16);
         this.designId = this.designId > 32767 ? int(this.designId - 65536) : this.designId;
         this.expansionStage = param1.readShort();
         this.expansionStage = 0xFFFF & ((0xFFFF & this.expansionStage) >>> 3 % 16 | (0xFFFF & this.expansionStage) << 16 - 3 % 16);
         this.expansionStage = this.expansionStage > 32767 ? int(this.expansionStage - 65536) : this.expansionStage;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(160);
         param1.writeShort(0xFFFF & ((0xFFFF & this.petLevel) >>> 14 % 16 | (0xFFFF & this.petLevel) << 16 - 14 % 16));
         param1.writeDouble(this.petExperiencePointsUntilNextLevel);
         param1.writeShort(0xFFFF & ((0xFFFF & this.designId) << 16 % 16 | (0xFFFF & this.designId) >>> 16 - 16 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.expansionStage) << 3 % 16 | (0xFFFF & this.expansionStage) >>> 16 - 3 % 16));
      }
   }
}

