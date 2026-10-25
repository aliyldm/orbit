package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class FactionInfluenceUpdateCommand implements IModule
   {
      
      private static var _instance:FactionInfluenceUpdateCommand;
      
      public var vruScore:Number = 0;
      
      public var eicScore:Number = 0;
      
      public var mmoScore:Number = 0;
      
      public function FactionInfluenceUpdateCommand(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.vruScore = param3;
         this.eicScore = param2;
         this.mmoScore = param1;
      }
      
      public static function get instance() : FactionInfluenceUpdateCommand
      {
         return _instance || (_instance = new FactionInfluenceUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26033;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.vruScore = param1.readDouble();
         this.eicScore = param1.readDouble();
         this.mmoScore = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(26033);
         param1.writeDouble(this.vruScore);
         param1.writeDouble(this.eicScore);
         param1.writeDouble(this.mmoScore);
      }
   }
}

