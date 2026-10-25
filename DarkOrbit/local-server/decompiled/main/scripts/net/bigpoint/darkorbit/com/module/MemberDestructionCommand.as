package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MemberDestructionCommand implements IModule
   {
      
      private static var _instance:MemberDestructionCommand;
      
      public var victimId:int = 0;
      
      public function MemberDestructionCommand(param1:int = 0)
      {
         super();
         this.victimId = param1;
      }
      
      public static function get instance() : MemberDestructionCommand
      {
         return _instance || (_instance = new MemberDestructionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7651;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.victimId = param1.readInt();
         this.victimId = this.victimId >>> 12 % 32 | this.victimId << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7651);
         param1.writeInt(this.victimId << 12 % 32 | this.victimId >>> 32 - 12 % 32);
      }
   }
}

