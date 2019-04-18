import discord
import os
TOKEN = 'Mzk2MjQyNzE1NjUxODY2NjM0.Duba5w.Sia5hjuy6qR1Zi0pe5qpXgAo554'

client = discord.Client()
good_boys = ['trial admin', 'host', 'game admin', 'trial event master']
exceptional_boys = ['host', 'game admin']

@client.event
async def on_message(message):
    # we do not want the bot to reply to itself
    if message.author == client.user:
        return
    
    if message.content.startswith('#help'):
        msg = ("```#whitelist\n#jobwhitelist\n#aleinwhitelist\n#showlist\n#whitelisthelp```").format(message)
        await client.send_message(message.channel, msg)
        return
    
    if message.content.startswith('#whitelisthelp'):
        msg = ("```#whitelist to add a CKEY to the whitelist. (any case/any spaces) \n#jobwhitelist to whitelist CKEY for a job. Format is 'ckey - job title' (case insesitive, SPACE SENSITIVE) \n#aleinwhitelist to whitelist CKEY for a species. Format is 'ckey - species' (case insesitive, SPACE SENSITIVE)```").format(message)
        await client.send_message(message.channel, msg)
        return

    if message.content.startswith('#whitelist'):
        for role in good_boys:
            print(role)
            if role in [y.name.lower() for y in message.author.roles]:
                whitelist_name = message.content.replace("#whitelist", "")
                whitelist_name = whitelist_name.replace(" ", "")
                whitelist_name = whitelist_name.lower()
                whitelist = open('config/playerwhitelist.txt','r').readlines()
                for i in whitelist:
                        if i == (whitelist_name +"\n"):
                            msg = (whitelist_name + ' is already whitelisted.').format(message)
                            await client.send_message(message.channel, msg)
                            return
                            break
                blacklist = open('config/blacklist.txt','r').readlines()
                for i in blacklist:
                        if i == (whitelist_name +"\n"):
                            msg = (whitelist_name + ' is blacklisted.').format(message)
                            await client.send_message(message.channel, msg)
                            return
                            break
                with open("config/playerwhitelist.txt", "a") as myfile:
                    myfile.write(whitelist_name + '\n')
                msg = ('Added ' + whitelist_name + ' to the whitelist.').format(message)
                await client.send_message(message.channel, msg)
                return
                break
                
            
        msg = ("I don't trust you.").format(message)
        await client.send_message(message.channel, msg)


    if message.content.startswith('#blacklist'):
        for role in good_boys:
            print(role)
            if role in [y.name.lower() for y in message.author.roles]:
                whitelist_name = message.content.replace("#blacklist", "")
                whitelist_name = whitelist_name.replace(" ", "")
                whitelist_name = whitelist_name.lower()
                with open("config/blacklist.txt", "a") as myfile:
                    myfile.write(whitelist_name + '\n')
                msg = ('Added ' + whitelist_name + ' to the blacklist.').format(message)
                await client.send_message(message.channel, msg)
                return
                break
                
            
        msg = ("I don't trust you.").format(message)
        await client.send_message(message.channel, msg)

    if message.content.startswith('#jobwhitelist'):
        for role in good_boys:
            print(role)
            if role in [y.name.lower() for y in message.author.roles]:
                whitelist_name = message.content.replace("#jobwhitelist ", "")
                whitelist_name = whitelist_name.lower()
               ## whitelist_name = message.content.replace("#jobwhitelist", "")
                with open("config/jobwhitelist.txt", "a") as myfile:
                    myfile.write(whitelist_name + '\n')
                msg = ('Added ' + whitelist_name + ' to the job whitelist.').format(message)
                await client.send_message(message.channel, msg)
                return
                break
                
            
        msg = ("I don't trust you.").format(message)
        await client.send_message(message.channel, msg)

    if message.content.startswith('#alienwhitelist'):
        for role in good_boys:
            print(role)
            if role in [y.name.lower() for y in message.author.roles]:
                whitelist_name = message.content.replace("#alienwhitelist ", "")
                whitelist_name = message.content.replace("#alienwhitelist", "")
                with open("config/alienwhitelist.txt", "a") as myfile:
                    myfile.write(whitelist_name + '\n')
                msg = ('Added ' + whitelist_name + ' to the species whitelist.').format(message)
                await client.send_message(message.channel, msg)
                return
                break
                
            
        msg = ("I don't trust you.").format(message)
        await client.send_message(message.channel, msg)



    if message.content.startswith('#showlist'):
        for role in good_boys:
            print(role)
            if role in [y.name.lower() for y in message.author.roles]:
                whitelist_name = message.content.replace("#showlist ", "")
                if whitelist_name == "whitelist":
                    await client.send_file(message.channel, "config/playerwhitelist.txt")
                    return
                    break
                
                if whitelist_name == "jobs":
                    await client.send_file(message.channel, "config/jobwhitelist.txt")
                    return
                    break

                if whitelist_name == "races":
                    await client.send_file(message.channel, "config/alienwhitelist.txt")
                    return
                    break

                if whitelist_name == "list":
                    msg = ('Available lists - whitelist, jobs, races').format(message)
                    await client.send_message(message.channel, msg)
                    return
                    break

                else:
                    msg = ('No such list.').format(message)
                    await client.send_message(message.channel, msg)
                    return
                    break
            
        msg = ("I don't trust you.").format(message)
        await client.send_message(message.channel, msg)

    if message.content.startswith('#unwhitelist'):
        for role in good_boys:
            print(role)
            if role in [y.name.lower() for y in message.author.roles]:
                whitelist_name = message.content.replace("#unwhitelist", "")
                whitelist_name = whitelist_name.replace(" ", "")
                whitelist_name = whitelist_name.lower()
                wholelist = open('config/playerwhitelist.txt','r').readlines()
                with open("config/playerwhitelist.txt", "w") as myfile:
                   # myfile.seek(0)
                    for i in wholelist:
                        if i != (whitelist_name +"\n"):
                            myfile.write(i)
                    myfile.truncate()
                msg = ('Removed ' + whitelist_name + ' from the whitelist.').format(message)
                await client.send_message(message.channel, msg)
                return
                break
                
            
        msg = ("I don't trust you.").format(message)
        await client.send_message(message.channel, msg)

    if message.content.startswith('#stop_the_server'):
        for role in exceptional_boys:
            print(role)
            print(message.channel)
            if role in [y.name.lower() for y in message.author.roles]:
                os.system("killall DreamDaemon")
                await client.send_message(message.channel, "Killed the server.")
                return
                break

    
    if message.content.startswith('#start_the_server'):
        for role in exceptional_boys:
            print(role)
            print(message.channel)
            if role in [y.name.lower() for y in message.author.roles]:
                os.system("DreamDaemon eclipsestation.dmb 1780 -trusted -logself")
                await client.send_message(message.channel, "Started the server.")
                return
                break


@client.event
async def on_ready():
    print('Logged in as')
    print(client.user.name)
    print(client.user.id)
    print('------')

    await client.change_presence(game=discord.Game(name="chess with the boatman"))
    


client.run(TOKEN)
