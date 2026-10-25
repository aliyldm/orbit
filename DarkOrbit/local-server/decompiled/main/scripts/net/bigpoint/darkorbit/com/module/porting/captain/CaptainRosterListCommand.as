package net.bigpoint.darkorbit.com.module.porting.captain
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class CaptainRosterListCommand implements IModule
   {
      
      private static var _instance:CaptainRosterListCommand;
      
      public var captainList:Vector.<CaptainCommand>;
      
      public function CaptainRosterListCommand(param1:Vector.<CaptainCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.captainList = new Vector.<CaptainCommand>();
         }
         else
         {
            this.captainList = param1;
         }
      }
      
      public static function get instance() : CaptainRosterListCommand
      {
         return _instance || (_instance = new CaptainRosterListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 22281;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CaptainCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.captainList.length > 0)
         {
            this.captainList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CaptainCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.captainList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CaptainCommand = null;
         param1.writeShort(22281);
         param1.writeByte(this.captainList.length);
         for each(_loc2_ in this.captainList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

