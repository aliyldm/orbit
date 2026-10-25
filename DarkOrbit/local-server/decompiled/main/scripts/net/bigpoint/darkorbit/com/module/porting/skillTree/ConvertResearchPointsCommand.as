package net.bigpoint.darkorbit.com.module.porting.skillTree
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ConvertResearchPointsCommand implements IModule
   {
      
      private static var _instance:ConvertResearchPointsCommand;
      
      public var required:int = 0;
      
      public var success:Boolean = false;
      
      public var researchPoints:int = 0;
      
      public var logfiles:int = 0;
      
      public function ConvertResearchPointsCommand(param1:Boolean = false, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.required = param4;
         this.success = param1;
         this.researchPoints = param3;
         this.logfiles = param2;
      }
      
      public static function get instance() : ConvertResearchPointsCommand
      {
         return _instance || (_instance = new ConvertResearchPointsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17453;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.required = param1.readInt();
         this.required = this.required >>> 4 % 32 | this.required << 32 - 4 % 32;
         this.success = param1.readBoolean();
         this.researchPoints = param1.readInt();
         this.researchPoints = this.researchPoints << 15 % 32 | this.researchPoints >>> 32 - 15 % 32;
         this.logfiles = param1.readInt();
         this.logfiles = this.logfiles << 14 % 32 | this.logfiles >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(17453);
         param1.writeInt(this.required << 4 % 32 | this.required >>> 32 - 4 % 32);
         param1.writeBoolean(this.success);
         param1.writeInt(this.researchPoints >>> 15 % 32 | this.researchPoints << 32 - 15 % 32);
         param1.writeInt(this.logfiles >>> 14 % 32 | this.logfiles << 32 - 14 % 32);
      }
   }
}

