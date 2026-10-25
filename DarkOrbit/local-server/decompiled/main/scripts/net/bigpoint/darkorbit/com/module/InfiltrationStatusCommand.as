package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InfiltrationStatusCommand implements IModule
   {
      
      private static var _instance:InfiltrationStatusCommand;
      
      public var currentNpcs:int = 0;
      
      public var maxNpcs:int = 0;
      
      public var secondsRemaining:int = 0;
      
      public function InfiltrationStatusCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.currentNpcs = param1;
         this.maxNpcs = param2;
         this.secondsRemaining = param3;
      }
      
      public static function get instance() : InfiltrationStatusCommand
      {
         return _instance || (_instance = new InfiltrationStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4712;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.currentNpcs = param1.readInt();
         this.currentNpcs = this.currentNpcs >>> 2 % 32 | this.currentNpcs << 32 - 2 % 32;
         this.maxNpcs = param1.readInt();
         this.maxNpcs = this.maxNpcs >>> 15 % 32 | this.maxNpcs << 32 - 15 % 32;
         this.secondsRemaining = param1.readInt();
         this.secondsRemaining = this.secondsRemaining << 13 % 32 | this.secondsRemaining >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4712);
         param1.writeInt(this.currentNpcs << 2 % 32 | this.currentNpcs >>> 32 - 2 % 32);
         param1.writeInt(this.maxNpcs << 15 % 32 | this.maxNpcs >>> 32 - 15 % 32);
         param1.writeInt(this.secondsRemaining >>> 13 % 32 | this.secondsRemaining << 32 - 13 % 32);
      }
   }
}

