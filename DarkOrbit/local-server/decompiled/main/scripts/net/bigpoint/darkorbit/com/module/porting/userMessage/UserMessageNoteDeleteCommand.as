package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.*;
   
   public class UserMessageNoteDeleteCommand implements IModule
   {
      
      private static var _instance:UserMessageNoteDeleteCommand;
      
      public var noteId:int = 0;
      
      public var commandList:Vector.<UserMessageNoteInfoCommand>;
      
      public var success:Boolean = false;
      
      public var textCommand:BaseStackCommand;
      
      public var titleCommand:BaseStackCommand;
      
      public function UserMessageNoteDeleteCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null, param4:BaseStackCommand = null, param5:Vector.<UserMessageNoteInfoCommand> = null)
      {
         super();
         this.noteId = param1;
         if(param5 == null)
         {
            this.commandList = new Vector.<UserMessageNoteInfoCommand>();
         }
         else
         {
            this.commandList = param5;
         }
         this.success = param2;
         if(param4 == null)
         {
            this.textCommand = new BaseStackCommand();
         }
         else
         {
            this.textCommand = param4;
         }
         if(param3 == null)
         {
            this.titleCommand = new BaseStackCommand();
         }
         else
         {
            this.titleCommand = param3;
         }
      }
      
      public static function get instance() : UserMessageNoteDeleteCommand
      {
         return _instance || (_instance = new UserMessageNoteDeleteCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19318;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UserMessageNoteInfoCommand = null;
         this.noteId = param1.readInt();
         this.noteId = this.noteId << 9 % 32 | this.noteId >>> 32 - 9 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.commandList.length > 0)
         {
            this.commandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = UserMessageNoteInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.commandList.push(_loc4_);
            _loc2_++;
         }
         this.success = param1.readBoolean();
         this.textCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.textCommand)
         {
            this.textCommand.read(param1);
         }
         this.titleCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.titleCommand)
         {
            this.titleCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UserMessageNoteInfoCommand = null;
         param1.writeShort(19318);
         param1.writeInt(this.noteId >>> 9 % 32 | this.noteId << 32 - 9 % 32);
         param1.writeByte(this.commandList.length);
         for each(_loc2_ in this.commandList)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.success);
         if(null != this.textCommand)
         {
            this.textCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.titleCommand)
         {
            this.titleCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

