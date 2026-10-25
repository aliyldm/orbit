package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ClanNewsListCommand implements IModule
   {
      
      private static var _instance:ClanNewsListCommand;
      
      public var newsList:Vector.<ClanNewsInfoCommand>;
      
      public function ClanNewsListCommand(param1:Vector.<ClanNewsInfoCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.newsList = new Vector.<ClanNewsInfoCommand>();
         }
         else
         {
            this.newsList = param1;
         }
      }
      
      public static function get instance() : ClanNewsListCommand
      {
         return _instance || (_instance = new ClanNewsListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2333;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ClanNewsInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.newsList.length > 0)
         {
            this.newsList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ClanNewsInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.newsList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ClanNewsInfoCommand = null;
         param1.writeShort(2333);
         param1.writeByte(this.newsList.length);
         for each(_loc2_ in this.newsList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

