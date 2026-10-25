package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttributeLevelUpUpdateCommand implements IModule
   {
      
      private static var _instance:AttributeLevelUpUpdateCommand;
      
      public var level:int = 0;
      
      public var epToNextLevel:int = 0;
      
      public function AttributeLevelUpUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.level = param1;
         this.epToNextLevel = param2;
      }
      
      public static function get instance() : AttributeLevelUpUpdateCommand
      {
         return _instance || (_instance = new AttributeLevelUpUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 95;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.level = param1.readInt();
         this.level = this.level << 5 % 32 | this.level >>> 32 - 5 % 32;
         this.epToNextLevel = param1.readInt();
         this.epToNextLevel = this.epToNextLevel >>> 3 % 32 | this.epToNextLevel << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(95);
         param1.writeInt(this.level >>> 5 % 32 | this.level << 32 - 5 % 32);
         param1.writeInt(this.epToNextLevel << 3 % 32 | this.epToNextLevel >>> 32 - 3 % 32);
      }
   }
}

