import discord
from discord.ext import commands
from discord import app_commands
import sys
import os
from export import *

intents = discord.Intents.all()
bot = commands.Bot(intents=intents, command_prefix = '.', help_command = None)
f = open('bot.key')

@bot.event
async def on_ready():
    print(f'We have logged in as {bot.user}')
    try:
        s = await bot.tree.sync()
    except Exception as e:
        print(e)    

@bot.tree.command(name = 'latency', description = 'Shows the latency')
async def latency(interaction: discord.Interaction):
    await interaction.response.send_message('Latency is: ' + str(bot.latency) + 's')
    
@bot.tree.command(name='start-scan')
async def sstart(interaction: discord.Interaction):
    os.system('sudo systemctl start scanner')
    await interaction.response.send_message('started scanning')
    
@bot.tree.command(name='stop-scan')
async def sstop(interaction: discord.Interaction):
    os.system('sudo systemctl stop scanner')
    await interaction.response.send_message('stopped scanning')
    
@bot.tree.command(name='export')
async def export(interaction: discord.Interaction):
    main()
    await interaction.response.send_message('done exporting :white_check_mark:')

@bot.tree.command(name='clear')
async def clear(interaction: discord.Interaction):
    os.remove('wifi_networks.json')
    await interaction.response.send_message('cleared :white_check_mark:')
    
@bot.tree.command(name='generate')
async def generate(interaction: discord.Interaction):
    os.system('bash generator.sh')
    await interaction.response.send_message('finished generating :white_check_mark:')
    
@bot.tree.command(name='start-nginx')
async def nstart(interaction: discord.Interaction):
    os.system('sudo cp index.html /var/www/html/statistics.html')
    os.system('sudo systemctl start nginx')
    await interaction.response.send_message('started nginx')
    
@bot.tree.command(name='stop-nginx')
async def nstart(interaction: discord.Interaction):
    os.system('sudo systemctl stop nginx')
    await interaction.response.send_message('stopped nginx')
    
@bot.tree.command(name='refresh-statistics-page')
async def rsp(interaction: discord.Interaction):
    os.system('sudo cp index.html /var/www/html/statistics.html')
    await interaction.response.send_message('refreshed :white_check_mark:')
    
bot.run(f.read())