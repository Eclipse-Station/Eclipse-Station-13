import discord

TOKEN = 'Mzk2MjQyNzE1NjUxODY2NjM0.Duba5w.Sia5hjuy6qR1Zi0pe5qpXgAo554'

client = discord.Client()
good_boys = ['trial admin', 'host', 'game admin', 'trial event master']
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
                with open("config/playerwhitelist.txt", "a") as myfile:
                    myfile.write(whitelist_name + '\n')
                msg = ('Added ' + whitelist_name + ' to the whitelist.').format(message)
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
                    with open("config/playerwhitelist.txt", "r") as myfile:
                       whitelist_name = myfile.readlines()
                       whitelist_name = "".join(whitelist_name)
                    msg = ('```' + whitelist_name + '```').format(message)
                    await client.send_message(message.channel, msg)
                    return
                    break
                
                if whitelist_name == "jobs":
                    with open("config/jobwhitelist.txt", "r") as myfile:
                       whitelist_name = myfile.readlines()
                       whitelist_name = "".join(whitelist_name)
                    msg = ('```' + whitelist_name + '```').format(message)
                    await client.send_message(message.channel, msg)
                    return
                    break

                if whitelist_name == "races":
                    with open("config/alienwhitelist.txt", "r") as myfile:
                       whitelist_name = myfile.readlines()
                       whitelist_name = "".join(whitelist_name)
                    msg = ('```' + whitelist_name + '```').format(message)
                    await client.send_message(message.channel, msg)
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

    



@client.event
async def on_ready():
    print('Logged in as')
    print(client.user.name)
    print(client.user.id)
    print('------')

    await client.change_presence(game=discord.Game(name="human souls"))


client.run(TOKEN)
